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
        parse_fail2ban = {
          type = "remap";
          inputs = [ "fail2ban" ];
          source = ''
            if !contains(string!(.PRIORITY), "5") {
              abort
            }

            .message = string!(.MESSAGE)
            .jail = parse_regex(.message, ".*\\[([^\\[]+)\\].*")
            .host = "${config.networking.hostName}"

            if contains(.message, "Ban") {
              .action = "ban"
              .ip = parse_regex(.message, ".*Ban ([^ ]+).*")
            } else if contains(.message, "Unban") {
              .action = "unban"
              .ip = parse_regex(.message, ".*Unban ([^ ]+).*")
            } else {
              abort
            }
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
          inputs = [ "add_hostname" ];
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
          inputs = [ "add_metadata" ];
          endpoint = "http://${net.internal.rome}:${toString vars.services.loki.http_port}";
          encoding.codec = "json";

          labels = {
            job = "{{ job }}";
            host = "{{ host }}";
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
