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

      allowedTCPPorts = [ 80 443 ];
    };
  };

  # DNS Service
  services.dnsmasq = {
    enable = true;
    settings = {
      server = [ "8.8.8.8" "1.1.1.1" ];
      interface = vars.network.interfaces.lan;
    };
  };
}
