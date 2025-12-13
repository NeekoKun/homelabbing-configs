{ vars, ... }:

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

        suricata = {
          type = "file";
          include = [ "/var/log/suricata/eve.json" ];
        };

        host_metrics = {
          type = "host_metrics";
          collectors = [ "cpu" "memory" "network" "disk" ];
        };
      };

      transforms = {
        add_metadata = {
          type = "remap";
          inputs = [ "journald" "suricata" "host_metrics" ];
          source = ''
            .host = "${net.internal.gateway}"
            .role = "gateway"
          '';
        };
      };

      sinks = {
        loki = {
          type = "loki";
          inputs = [ "add_metadata" ];
          endpoint = "http://${net.internal.loki}:${toString vars.services.loki.http_listen_port}";
          encoding.codec = "json";
          labels.host = "{{ host }}";
        };
      };
    };
  };
}
