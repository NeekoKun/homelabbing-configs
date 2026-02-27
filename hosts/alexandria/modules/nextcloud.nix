{ config, vars, flakeRoot, pkgs, ... }:

let
  net = vars.network;
in
{
  age.secrets.nextcloudAdminPassword.file = "${flakeRoot}/secrets/nextcloud-admin-password.age";
  
  services.nginx.enable = true;

  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.${vars.network.DNS.domain}.${vars.network.DNS.tld}";
    https = false;
    config = {
      adminpassFile = config.age.secrets.nextcloudAdminPassword.path;
      dbtype = "sqlite";
    };

    settings = {
      overwriteprotocol = "https";
      overwritehost = "nextcloud.${vars.network.DNS.domain}.${vars.network.DNS.tld}";
      trusted_domains = [
        vars.network.internal.istanbul
        vars.network.internal.alexandria
        "nextcloud.${vars.network.DNS.domain}.${vars.network.DNS.tld}"
      ];
      trusted_proxies = [ vars.network.internal.istanbul ];
    };
  };

  services.nginx.virtualHosts."nextcloud.${net.DNS.domain}.${net.DNS.tld}" = {
    listen = [{ addr = net.internal.alexandria; port = 80; }];
    forceSSL = false;
  };
}
