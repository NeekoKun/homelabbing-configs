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

    virtualHosts."nextcloud.${net.DNS.domain}.${net.DNS.tld}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://${vars.network.internal.alexandria}:80/";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };

    virtualHosts."navidrome.${net.DNS.domain}.${net.DNS.tld}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://${vars.network.internal.alexandria}:${toString vars.services.navidrome.http_port}/";
      };
    };

    virtualHosts."grafana.${net.DNS.domain}.${net.DNS.tld}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://${vars.network.internal.rome}:${toString vars.services.grafana.port}/";
      };
    };

    virtualHosts."matrix.${net.DNS.domain}.${net.DNS.tld}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://${vars.network.internal.babylon}:${toString vars.services.synapse.http_port}/";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Host $host;
          client_max_body_size 50M;
        '';
      };
    };

    virtualHosts."${net.DNS.domain}.${net.DNS.tld}" = {
      enableACME = true;
      forceSSL = true;

      locations."/.well-known/matrix/server" = {
        return = ''200 "{\"m.server\": \"matrix.${net.DNS.domain}.${net.DNS.tld}:443\"}"'';
        extraConfig = ''
          add_header Content-Type application/json;
        '';
      };

      locations."/.well-known/matrix/client" = {
        return = ''200 "{\"m.homeserver\": {\"base_url\": \"https://matrix.${net.DNS.domain}.${net.DNS.tld}\"}}"'';
        extraConfig = ''
          add_header Content-Type application/json;
          add_header Access-Control-Allow-Origin *;
        '';
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
