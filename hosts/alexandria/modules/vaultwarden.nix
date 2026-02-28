{ config, vars, pkgs, flakeRoot, ... }:

{
  age.secrets.vaultwarden-env.file = "${flakeRoot}/secrets/vaultwarden-env.age";

  services.vaultwarden = {
    enable = true;
    backupDir = "/home/vaultwarden/data";
    environmentFile = config.age.secrets.vaultwarden-env.path;

    config = {
      DOMAIN = "https://vaultwarden.${vars.network.DNS.domain}.${vars.network.DNS.tld}";
      SIGNUPS_ALLOWED = "false";

      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = vars.services.vaultwarden.http_port;
      ROCKET_LOG = "error";
    };
  };
}
