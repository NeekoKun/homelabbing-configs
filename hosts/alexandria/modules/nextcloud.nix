{ config, vars, flakeRoot, pkgs, ... }:


{
  age.secrets.nextcloudAdminPassword = {
    file = "${flakeRoot}/secrets/nextcloud-admin-password.age";
    owner = "nextcloud";
  };

  age.secrets.nextcloudDatabasePassword = {
    file = "${flakeRoot}/secrets/nextcloud-database-password.age";
    owner = "nextcloud";
  };

  age.secrets.postgresqlPassword = {
    file = "${flakeRoot}/secrets/nextcloud-database-password.age";
    owner = "postgresql";
  };

  services.nginx.enable = true;

  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.${vars.network.DNS.domain}.${vars.network.DNS.tld}";

    package = pkgs.nextcloud32;

    https = false;
    config = {
      adminpassFile = config.age.secrets.nextcloudAdminPassword.path;
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbname = "nextcloud";
      dbhost = "/run/postgresql";
    };

    settings = {
      overwriteprotocol = "https";
      trusted_domains = [
        vars.network.internal.istanbul
        vars.network.internal.alexandria
      ];
      trusted_proxies = [ vars.network.internal.istanbul ];
    };

    # Enable CalDAV and CardDAV
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
    };
    extraAppsEnable = true;
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
