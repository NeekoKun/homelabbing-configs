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
          inputs = [ "journald" "suricata" ];
          source = ''
            .host = "${net.internal.istanbul}"
            .role = "gateway"
          '';
        };
      };

      sinks = {
        loki = {
          type = "loki";
          inputs = [ "add_metadata" ];
          endpoint = "http://${net.internal.rome}:${toString vars.services.loki.http_port}";
          encoding.codec = "json";
          labels.host = "{{ host }}";
        };
      };
    };
  };
}
