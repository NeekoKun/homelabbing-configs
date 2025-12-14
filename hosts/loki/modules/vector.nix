{ config, vars, ... }:

let
  net = vars.network;
in
{
  services.vector = {
    enable = true;

    settings = {
      sources = {
        journald = {
          type = "journald";
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
            .host = "${net.internal.loki}"
            .service = "${config.networking.hostName}"
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
            host = "{{ host }}";
            serice = "{{ service }}";
          };
        };
      };
    };
  };
}
