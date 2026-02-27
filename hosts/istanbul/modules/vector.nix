{ config, vars, ... }:

let
  net = vars.network;
in
{
  services.vector = {
    enable = true;

    journaldAccess = true;

    settings = {
      api = {
        enabled = true;
        address = "127.0.0.1:8686";
      };

      sources = {
        fail2ban = {
          type = "journald";
          include_matches = {
            _SYSTEMD_UNIT = [ "fail2ban.service" ];
          };
        };

        nginx_logs = {
          type = "file";
          include = [ "/var/log/nginx/access.log" ];
        };

        journald = {
          type = "journald";
          exclude_matches = {
            _SYSTEMD_UNIT = [ "vector.service" ];
          };
        };

        host_metrics = {
          type = "host_metrics";
          collectors = [ "cpu" "memory" "network" "filesystem" ];
          scrape_interval_secs = 15;
        };
      };

      transforms = {
        parse_nginx = {
          type = "remap";
          inputs = [ "nginx_logs" ];
          source = ''
            if !exists(.message) {
                abort
            }
            cleaned, err = strip_whitespace(.message)

            if err != null {
                cleaned = .message
            }

            parsed, err = parse_json(cleaned)

            if err != null {
                abort
            }
                          
            .time_local = parsed.time_local
            .remote_addr = parsed.remote_addr
            .request = parsed.request
            .status = parsed.status
            .body_bytes_sent = parsed.body_bytes_sent
            .http_referer = parsed.http_referer
            .http_user_agent = parsed.http_user_agent
            .http_x_forwarded_for = parsed.http_x_forwarded_for
            .request_time = parsed.request_time
                          
            request_parts, err = parse_regex(.request, r'^(?P<method>\S+) (?P<uri>[^\s]+) (?P<protocol>[^"]+)$')

            if err != null {
                .request_method = "UNKNOWN"
                .request_uri = "/"
                .request_protocol = "HTTP/1.1"
            } else {
                .request_method = request_parts.method
                .request_uri = request_parts.uri
                .request_protocol = request_parts.protocol
            }
                          
            .body_bytes_sent, err = if .body_bytes_sent == "" || .body_bytes_sent == null { 0 } else { to_int(.body_bytes_sent) }
            .request_method = if .request_method == "" || .request_method == null { "UNKNOWN" } else { .request_method }
            .status = if .status == "" || .status == null { "000" } else { .status }
            .request_uri = if .request_uri == "" || .request_uri == null { "/" } else { .request_uri }
            .request_time, err = if .request_time == "" || .request_time == null { 0.0 } else { to_float(.request_time) }
            .count = 1
            .job = "nginx"
          '';
        };

        extract_nginx_metrics = {
          type = "log_to_metric";
          inputs = [ "parse_nginx" ];
          metrics = [
            {
              type = "counter";
              name = "nginx_http_response_count_total";
              description = "Total HTTP requests";
              field = "count";
              tags.method = ".request_method";
              tags.status = ".status";
              tags.path = ".request_uri";
              tags.instance = "\"${config.networking.hostName}\"";
            }
            {
              type = "gauge";
              name = "nginx_http_response_size_bytes";
              description = "Total bytes sent";
              field = "body_bytes_sent";
              tags.method = ".request_method";
              tags.status = ".status";
              tags.instance = "\"${config.networking.hostName}\"";
            }
            {
              type = "histogram";
              name = "nginx_http_response_time_seconds";
              description = "Request processing time in seconds";
              field = "request_time";
              tags.method = ".request_method";
              tags.status = ".status";
              tags.instance = "\"${config.networking.hostName}\"";
            }
          ];
        };

        parse_fail2ban = {
          type = "remap";
          inputs = [ "fail2ban" ];
          source = ''
            if !contains(string!(.PRIORITY), "5") {
              abort
            }

            .message = string!(.message)
            if contains(.message, "Ban") {
              .action = "ban"
              parsed, err = parse_regex(.message, r'^.*Ban (?P<ip>.+)$')
              if err != null { abort }
              .ip = parsed.ip
            } else if contains(.message, "Unban") {
              .action = "unban"
              parsed, err = parse_regex(.message, r'^.*Unban (?P<ip>.+)$')
              if err != null { abort }
              .ip = parsed.ip
            } else {
              abort
            }

            .level = if .action == "ban" { "warn" } else { "info" }
            .job = "fail2ban"
            .jail = "sshd"
            .host = "${config.networking.hostName}"
          '';
        };

        add_hostname = {
          type = "remap";
          inputs = [ "host_metrics" ];
          source = ''
            .host = "${config.networking.hostName}"
          '';
        };

        add_metadata = {
          type = "remap";
          inputs = [ "journald" ];
          source = ''
            .job = "vector"
            .host = "${config.networking.hostName}"

            if exists(._SYSTEMD_UNIT) {
              .unit = string!(._SYSTEMD_UNIT)
            }

            if exists(.MESSAGE) {
              .message = string!(.MESSAGE)
            }
          '';
        };
      };

      sinks = {
        prometheus = {
          type = "prometheus_remote_write";
          inputs = [ "add_hostname" "extract_nginx_metrics" ];
          endpoint = "http://${net.internal.rome}:${toString vars.services.prometheus.http_port}/api/v1/write";

          healthcheck.enabled = true;

          batch = {
            max_events = 1000;
            timeout_secs = 1;
          };

          request = {
            retry_attempts = 5;
            timeout_secs = 60;
          };
        };

        loki = {
          type = "loki";
          inputs = [ "add_metadata" "parse_fail2ban" "parse_nginx" ];
          endpoint = "http://${net.internal.rome}:${toString vars.services.loki.http_port}";
          encoding.codec = "json";

          labels = {
            job = "{{ job }}";
            host = "{{ host }}";
            level = "{{ level }}";
          };

          remove_label_fields = true;

          batch = {
            max_bytes = 1048576;
            timeout_secs = 1;
          };

          out_of_order_action = "accept";
        };

        debug_metrics = {
          type = "console";
          inputs = [ "add_hostname" ];
          encoding.codec = "json";
          target = "stdout";
        };
      };
    };
  };

  systemd.services.vector = {
    environment = {
      VECTOR_LOG = "warn";
    };

    serviceConfig = {
      LogRateLimitIntervalSec = 0;
      LogRateLimitBurst = 0;
    };
  };
}
