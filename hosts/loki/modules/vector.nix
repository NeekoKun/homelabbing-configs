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
        journald = {
          type = "journald";
          exclude_matches = {
            _SYSTEMD_UNIT = [ "vector.service" ];
          };
        };

        host_metrics = {
          type = "host_metrics";
          collectors = [ "cpu" "memory" "disk" "filesystem" ];
        };
      };

      transforms = {
        add_metadata = {
          type = "remap";
          inputs = [ "journald" "host_metrics" ];
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
        loki = {
          type = "loki";
          inputs = [ "add_metadata" ];
          endpoint = "http://${net.internal.loki}:${toString vars.services.loki.http_port}";
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
