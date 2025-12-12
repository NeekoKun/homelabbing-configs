{ configs, pkgs, ... }:

{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking = {
    interfaces = {
      enp0s3 = {
        ipv4.addresses = [{
          address = "192.168.2.1"; # This machine functions as gateway of the internal network
          prefixLength = 24;
      }];
    };
  };

  nat = {
    enable = true;
    
    externalInterface = "enp0s8";
    internalInterfaces = [ "enp0s3" ];
  };

  firewall = {
    enable = true;

    extraCommands = ''
      iptables -A FORWARD -i enp0s3 -o enp0s8 -j ACCEPT
      iptables -A FORWARD -i enp0s8 -o enp0s3 -j ACCEPT #-m state --state RELATED,ESTABLISHED -j ACCEPT
    '';
    };
  };
}
