{ vars }:
{ configs, pkgs, ... }:

let
  net = vars.network;
in
{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking = {
    interfaces = {
      ${net.interfaces.lan} = {
        ipv4.addresses = [{
          address = net.internal.gateway; # This machine functions as gateway of the internal network
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

    extraCommands = ''
      iptables -A FORWARD -i ${net.interfaces.wan} -o ${net.interfaces.lan} -j ACCEPT
      iptables -A FORWARD -i ${net.interfaces.lan} -o ${net.interfaces.wan} -j ACCEPT
    '';
    };
  };
}
