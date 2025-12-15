{ vars, ... }:

let
  net = vars.network;
in
{
  networking = {
    hostName = "rome";
    useDHCP = false;

    interfaces = {
      ${net.interfaces.lan} = {
        useDHCP = false;
        ipv4.addresses = [{
          address = net.internal.rome;
          prefixLength = 24;
        }];
      };
    };

    defaultGateway = {
      address = net.internal.istanbul;
      interface = net.interfaces.lan;
    };

    nameservers = [ "8.8.8.8" "8.8.4.4" ];

    firewall = {
      enable = true;

      allowedTCPPorts = [
        vars.services.grafana.port
        vars.services.loki.http_port
        vars.services.prometheus.http_port
        9090
      ];
    };
  };
}

