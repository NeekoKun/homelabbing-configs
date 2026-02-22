{ pkgs, vars, ... }:

let
  net = vars.network;
in
{
  environment.systemPackages = with pkgs; [
    nginx
  ];

  services.nginx = {
    enable = true;

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts."navidrome.${net.DNS.domain}.${net.DNS.tld}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://${vars.network.internal.thebes}:${toString vars.services.navidrome.http_port}/";
      };
    };

    virtualHosts."grafana.${net.DNS.domain}.${net.DNS.tld}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://${vars.network.internal.rome}:${toString vars.services.grafana.port}/";
        #extraConfig = ''
        #  proxy_set_header Host $host;
        #  proxy_set_header X-Real-IP $remote_addr;
        #  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        #  proxy_set_header X-Forwarded-Proto $scheme;
        #'';
      };
    };
  };

  systemd.services.nginx.serviceConfig = {
    StartLimitIntervalSec = 0; # Avoid STUPID crash due to restarts
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "neekokun@proton.me";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
