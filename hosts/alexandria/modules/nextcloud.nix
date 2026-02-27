{ config, vars, flakeRoot, pkgs, ... }:

{
  age.secrets.nextcloudAdminPassword.file = "${flakeRoot}/secrets/nextcloud-admin-password.age";
  
  services.nginx.enable = true;

  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.${vars.network.DNS.domain}.${vars.network.DNS.tld}";
    config = {
      adminpassFile = config.age.secrets.nextcloudAdminPassword.path;
      dbtype = "sqlite";
    };

    settings = {
      overwriteprotocol = "https";
      trusted_domains = [ vars.network.internal.istanbul vars.network.internal.alexandria ];
      trusted_proxies = [ vars.network.internal.istanbul ];
    };
  };
}
