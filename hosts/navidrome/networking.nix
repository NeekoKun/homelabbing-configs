{ vars }:
{ config, pkgs, ... }:

let
  net = vars.network;
in
{
  networking = {
    hostName = "navidrome";
    useDHCP = false;

    interfaces = {
      ${net.interfaces.lan} = {
        useDHCP = false;
        ipv4.addresses = [{
          address = net.internal.navidrome;
          prefix = 24;
        }];
      };
    };

    defaultGateway = {
      address = net.internal.gateway;
      interface = net.interfaces.lan;
    };

    nameserver = [ "8.8.8.8" "8.8.4.4" ];
  };
}

