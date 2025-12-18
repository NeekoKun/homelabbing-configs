{ vars, ... }:

let
  net = vars.network;
in
{
  networking = {
    hostName = "thebes";
    useDHCP = false;

    interfaces = {
      ${net.interfaces.lan} = {
        useDHCP = false;
        ipv4.addresses = [{
          address = net.internal.thebes;
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
    };
  };
}

