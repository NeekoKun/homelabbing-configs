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
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking = {
    hosts = {
      ${net.internal.rome}    = [ "rome" ];
      ${net.internal.babylon} = [ "babylon" ];
      ${net.internal.alexandria}  = [ "alexandria" ];
    };

    hostName = "istanbul";
    interfaces = {
      ${net.interfaces.lan} = {
        ipv4.addresses = [{
          address = net.internal.istanbul; # This machine functions as gateway of the internal network
          prefixLength = 24;
        }];
      };
    };

    nat = {
      enable = true;

      externalInterface = net.interfaces.wan;
      internalInterfaces = [ net.interfaces.lan ];
    };

    firewall = {
      enable = true;

      interfaces.${net.interfaces.lan} = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };

      trustedInterfaces = [ net.interfaces.lan ];

      allowedTCPPorts = [
        80      # HTTP
        443     # HTTPS
        4343    # SSH
        vars.services.coturn.port
        vars.services.coturn.tls_port
      ];

      allowedUDPPorts = [
        vars.services.coturn.port
        vars.services.coturn.tls_port
      ];

      allowedUDPPortRanges = [
        { from = 49152; to = 65535; } # CoTURN
      ];

      extraCommands = ''
        # Clear any existing NAT rules to ensure a clean slate (optional)
        #iptables -t nat -F POSTROUTING
  
        # Explicitly masquerade everything leaving the WAN interface
        iptables -t nat -A POSTROUTING -o ${net.interfaces.wan} -j MASQUERADE
      '';
    };
  };

  # DNS Service
  services.dnsmasq = {
    enable = true;
    settings = {
      server = [ "8.8.8.8" "1.1.1.1" ];
      interface = net.interfaces.lan;
    };
  };
}
