{ config, vars, flakeRoot, ... }:

{
  age.secrets.nextcloudAdminPassword.file = "${flakeRoot}/secrets/nextcloud-admin-password.age";

  services.nextcloud = {
    enable = true;
    hostName = "localhost";
    config.adminPasswordFile = config.age.secrets.nextcloudAdminPassword.path;
    config.dbtype = "sqlite";
  }
}