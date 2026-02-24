{ vars, ... }:

let
  net = vars.network;
in
{
  networking = {
    hostName = "babylon";
    useDHCP = false;

    interfaces = {
      ${net.interfaces.lan} = {
        useDHCP = false;
        ipv4.addresses = [{
          address = net.internal.babylon;
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

      allowedTCPPorts = [  ]; # TODO: Open synapse com ports
      
      interfaces.${net.interfaces.lan} = {
        allowedTCPPorts = [
          22 # SSH from bastion
        ];
      };
    };
  };
}

