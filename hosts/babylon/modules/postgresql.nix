{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;

    ensureUsers = [
      {
        name = "matrix-synapse";
        ensureDBOwnership = true;
      }
    ];

    ensureDatabases = [ "matrix-synapse" ];

    initialScript = pkgs.writeText "synapse-pg-init" ''
    CREATE DATABASE "matrix-synapse"
      WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = 'C'
      LC_CTYPE = 'C';
    '';
  };
}
