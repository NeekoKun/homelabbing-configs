{ configs, pkgs, ... }:

{
  services.suricata = {
    enable = true;

    settings = {
      vars.address-groups = {
        HOME_NET = "[192.168.2.1/24]";
        EXTERNAL_NET = "!$HOME_NET";
      };

      outputs = [{
        eve-log = {
          enable = true;
          filetype = "regular";
          filename = "eve.json";

          types = [
            { alert.tagged-packets = true; }
            { http = {}; }
            { dns = {}; }
            { tls = {}; }
          ];
        };
      ];
    };
  };
}
