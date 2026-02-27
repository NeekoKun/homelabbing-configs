{ vars, ... }:

let
  net = vars.network;
in
{
  networking = {
    hostName = "alexandria";
    useDHCP = false;

    interfaces = {
      ${net.interfaces.lan} = {
        useDHCP = false;
        ipv4.addresses = [{
          address = net.internal.alexandria;
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

      allowedTCPPorts = [ vars.services.navidrome.http_port ];
      
      interfaces.${net.interfaces.lan} = {
        allowedTCPPorts = [
          22 # SSH from bastion
          80
          443 # For nextcloud, subject to change if reverse proxy is used
        ];
      };
    };
  };
}

