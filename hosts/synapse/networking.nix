{ vars, ... }:

let
  net = vars.network;
in
{
  networking = {
    hostName = "synapse";
    useDHCP = false;

    interfaces = {
      ${net.interfaces.lan} = {
        useDHCP = false;
        ipv4.addresses = [{
          address = net.internal.synapse;
          prefixLength = 24;
        }];
      };
    };

    defaultGateway = {
      address = net.internal.gateway;
      interface = net.interfaces.lan;
    };

    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };
}

