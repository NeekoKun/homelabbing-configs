{ config, vars, flakeRoot, pkgs, ... }:


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
      dbuser = "nextcloud";
      dbname = "nextcloud";
    };

    settings = {
      overwriteprotocol = "https";
      trusted_domains = [
        vars.network.internal.istanbul
        vars.network.internal.alexandria
      ];
      trusted_proxies = [ vars.network.internal.istanbul ];
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };

  # Ensure PostgreSQL is running before NextCloud setup
  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };
}
