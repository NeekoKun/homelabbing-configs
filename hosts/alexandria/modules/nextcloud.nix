{ config, vars, flakeRoot, ... }:

{
  age.secrets.nextcloudAdminPassword.file = "${flakeRoot}/secrets/nextcloud-admin-password.age";

  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.${vars.network.DNS.domain}.${vars.network.DNS.tld}";
    config = {
      adminpassFile = config.age.secrets.nextcloudAdminPassword.path;
      dbtype = "sqlite";
    };

    settings = {
      overwriteprotocol = "https";
      trusted_proxies = [ "${vars.network.internal.istanbul}" ];
    };
  };

  services.nginx.enable = true;
}