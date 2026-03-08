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
          enable = "yes";
          filetype = "regular";
          filename = "/var/log/suricata/eve.json";

          types = [
            {
              alert = {
                tagged-packets = "yes";
                metadata = true;
              };
            }
            { anomaly = { enabled = true; }; }
            { http = { enabled = true; }; }
            {
              tls = {
                extended = true;
                session-resumption = true;
              };
            }
            { ssh = { enabled = true; }; }
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
