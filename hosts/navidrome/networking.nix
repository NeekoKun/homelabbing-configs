{ config, pkgs, ... }:

{
  networking = {
    useDHCP = false;

    interfaces = {
      enp0s3 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "192.168.2.2";
          prefix = 24;
        }];
      };
    };

    defaultGateway = {
      address = "192.168.2.1";
      interface = "enp0s3";
    };

    nameserver = [ "8.8.8.8" "8.8.4.4" ];
  };
}

