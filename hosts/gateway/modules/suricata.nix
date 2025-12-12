{ vars }:
{ configs, pkgs, ... }:

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

      outputs = [{
        eve-log = {
          enable = true;
          filetype = "regular";
          filename = "eve.json";

          types = [
            {
              stats = {
                totals = true;
                threads = true;
                deltas = true;
              };
            }
            {
              alert = {
                tagged-packets = true;
                metadata = true;
              };
            }
            { anomaly = { enabled = true; }; }
            { http = {}; } #TODO: turn on when enabling https
            { dns = {}; }
            {
              tls = {
                extended = true;
                session-resumption = true;
              };
            }
            { ssh = {}; } #TODO: enable when starting ssh
          ];
        };
      }];
    };
  };
}
