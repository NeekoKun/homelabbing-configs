{ config, vars, flakeRoot, ... }:

{
  age.secrets.nextcloudAdminPassword.file = "${flakeRoot}/secrets/nextcloud-admin-password.age";

  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.${vars.network.DNS.domain}.${vars.network.DNS.tld}";
    trusted_domains = [ vars.network.internal.istanbul vars.network.internal.alexandria ];
    config = {
      adminpassFile = config.age.secrets.nextcloudAdminPassword.path;
      dbtype = "sqlite";
    };

    settings = {
      overwriteprotocol = "https";
      trusted_proxies = [ "${vars.network.internal.istanbul}" ];
    };
  };
}