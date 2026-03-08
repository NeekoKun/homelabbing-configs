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
in
{
  networking = {
    hostName = "rome";
    useDHCP = false;

    interfaces = {
      ${net.interfaces.lan} = {
        useDHCP = false;
        ipv4.addresses = [{
          address = net.internal.rome;
          prefixLength = 24;
        }];
      };
    };

    defaultGateway = {
      address = net.internal.istanbul;
      interface = net.interfaces.lan;
    };

    nameservers = [ vars.network.internal.istanbul "8.8.8.8" ];

    firewall = {
      enable = true;

      allowedTCPPorts = [
        vars.services.grafana.port
        vars.services.loki.http_port
        vars.services.prometheus.http_port
      ];
      
      interfaces.${net.interfaces.lan} = {
        allowedTCPPorts = [
          22 # SSH from bastion
        ];
      };
    };
  };
}

