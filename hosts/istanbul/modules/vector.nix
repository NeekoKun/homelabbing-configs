# Copyright (C) 2026 NeekoKun
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

{ config, vars, flakeRoot, ... }:

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

      enrichment_tables = {
        geoip_table = {
          path = "/var/lib/geoip/GeoLite2-City.mmdb";
          type = "geoip";
        };
      };

      sources = {
        fail2ban = {
          type = "journald";
          include_matches = {
            _SYSTEMD_UNIT = [ "fail2ban.service" ];
          };
        };

        caddy_metrics = {
          type = "prometheus_scrape";
          endpoints = [ "http://${net.internal.istanbul}:2019/metrics" ];
          scrape_interval_secs = 15;
        };

        caddy_logs = {
          type = "file";
          include = [
            "/var/log/caddy/access-*.log"
          ];
        };

        journald = {
          type = "journald";
          exclude_matches = {
            _SYSTEMD_UNIT = [ "vector.service" ];
          };
        };

        host_metrics = {
          type = "host_metrics";
          collectors = [ "cpu" "memory" "network" "filesystem" "disk" ];
          scrape_interval_secs = 15;
        };
      };

      transforms = {
        parse_caddy = {
          type = "remap";
          inputs = [ "caddy_logs" ];
          source = ''
            if .message == "" || .message == null {
              abort
            }

            parsed_message = parse_json!(.message)

            .remote_addr = parsed_message.request.remote_addr
            .status = parsed_message.status
            .http_user_agent = parsed_message.request.headers.User-Agent[0]
            .request_time = parsed_message.duration

            .request_method = parsed_message.request.method
            .request_uri = parsed_message.request.uri
            .request_protocol = parsed_message.request.proto
            
            .status, err = to_string(.status)
                          
            .request_method = if .request_method == "" || .request_method == null { "UNKNOWN" } else { .request_method }
            .status = if .status == "" || .status == null { "000" } else { .status }
            .request_uri = if .request_uri == "" || .request_uri == null { "/" } else { .request_uri }
            .request_time, err = if .request_time == "" || .request_time == null { 0.0 } else { to_float(.request_time) }
            .count = 1
            .job = "caddy"
            .level = if starts_with(.status, "5") { "warn" } else { "info" }
            .host = "${config.networking.hostName}"
          '';
        };

        extract_caddy_metrics = {
          type = "log_to_metric";
          inputs = [ "parse_caddy" ];
          metrics = [
            {
              type = "counter";
              name = "caddy_http_response_count_total";
              description = "Total HTTP requests";
              field = "count";
              tags.method = "{{request_method}}";
              tags.status = "{{status}}";
              tags.path = "{{request_uri}}";
              tags.instance = "${config.networking.hostName}";
            }
            {
              type = "gauge";
              name = "caddy_http_response_size_bytes";
              description = "Total bytes sent";
              field = "body_bytes_sent";
              tags.method = "{{request_method}}";
              tags.status = "{{status}}";
              tags.instance = "${config.networking.hostName}";
            }
            {
              type = "histogram";
              name = "caddy_http_response_time_seconds";
              description = "Request processing time in seconds";
              field = "request_time";
              tags.method = "{{request_method}}";
              tags.status = "{{status}}";
              tags.instance = "${config.networking.hostName}";
            }
          ];
        };

        caddy_geoip_enrich = {
          type = "remap";
          inputs = [ "parse_caddy" ];
          source = ''
            .geoip = get_enrichment_table_record!("geoip_table", {"ip": .remote_addr})
          '';
        };

        parse_fail2ban = {
          type = "remap";
          inputs = [ "fail2ban" ];
          source = ''
            if !contains(string!(.PRIORITY), "5") {
              abort
            }

            del(.service_name)
            del(.SYSLOG_IDENTIFIER)
            del(.detected_level)

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
            .jail, err = parse_regex(.message, r'^.*\[(?P<jail>[^\]]+)\].*$').jail
            .host = "${config.networking.hostName}"
          '';
        };

        fail2ban_geoip_enrich = {
          type = "remap";
          inputs = [ "parse_fail2ban" ];
          source = ''
            .geoip = get_enrichment_table_record!("geoip_table", {"ip": .ip})
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
          inputs = [ "add_hostname" "extract_caddy_metrics" ];
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

        loki_fail2ban = {
          type = "loki";
          inputs = [ "fail2ban_geoip_enrich" ];
          endpoint = "http://${net.internal.rome}:${toString vars.services.loki.http_port}";
          encoding = {
            codec = "json";
          };

          labels = {
            job = "fail2ban";
            host = "{{ host }}";
            level = "{{ level }}";
            jail = "{{ jail }}";
            action = "{{ action }}";
          };

          structured_metadata = {
            ip = "{{ ip }}";
            country_name = "{{ geoip.country_name }}";
            city_name = "{{ geoip.city_name }}";
          };

          remove_label_fields = true;

          batch = {
            max_bytes = 1048576;
            timeout_secs = 1;
          };

          out_of_order_action = "accept";
        };

        loki_caddy = {
          type = "loki";
          inputs = [ "caddy_geoip_enrich" ];
          endpoint = "http://${net.internal.rome}:${toString vars.services.loki.http_port}";
          encoding.codec = "json";

          labels = {
            job = "caddy";
            host = "{{ host }}";
            level = "{{ level }}";
          };

          structured_metadata = {
            method = "{{ request_method }}";
            request_path = "{{ request_uri }}";
            status = "{{ status }}";
            country_name = "{{ geoip.country_name }}";
            city_name = "{{ geoip.city_name }}";
          };

          remove_label_fields = true;

          batch = {
            max_bytes = 1048576;
            timeout_secs = 1;
          };

          out_of_order_action = "accept";
        };

        loki_system = {
          type = "loki";
          inputs = [ "add_metadata" ];
          endpoint = "http://${net.internal.rome}:${toString vars.services.loki.http_port}";
          encoding.codec = "json";

          labels = {
            job = "system";
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
          inputs = [ "fail2ban_geoip_enrich" ];
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
