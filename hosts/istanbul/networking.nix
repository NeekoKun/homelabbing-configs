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

      interfaces.${net.interfaces.lan} = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };

      allowedTCPPorts = [
        80      # HTTP
        443     # HTTPS
        4343    # SSH
      ];
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
