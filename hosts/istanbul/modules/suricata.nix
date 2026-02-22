{ vars, ... }:

let
  net = vars.network;
in {
  services.suricata = {
    enable = true;

    settings = {
      vars.address-groups = {
        HOME_NET = "[${net.internal.subnet}]";
        EXTERNAL_NET = "!$HOME_NET";
      };

      af-packet = [{
        interface = "${net.interfaces.wan}";
        threads = 2;
        cluster-type = "cluster_flow";
        defrag = true;
        use-mmap = true;
      }];

      app-layer.protocols = {
        modbus.enabled = "no";
        dnp3.enabled = "no";
        enip.enabled = "no";
      };

      outputs = [{
        eve-log = {
          enable = true;
          filetype = "regular";
          filename = "/var/log/suricata/eve.json";

          types = [
            {
              alert = {
                tagged-packets = true;
                metadata = true;
              };
            }
            { anomaly = { enabled = true; }; }
            { http = {}; } #TODO: enable yesterday
            {
              tls = {
                extended = true;
                session-resumption = true;
              };
            }
            { ssh = {}; } #TODO: enable when starting ssh

            {
              stats = {
                totals = true;
                deltas = true;
                threads = true;
              };
            }
          ];
        };
      }];
    };
  };
}
