{ config, pkgs, ... }:

{
  service.postgresql = {
    enable = true;

    ensureUsers = [
      {
        name = "matrix-synapse";
        ensureDBOwnership = true;
      }
    ];

    initialScript = pkgs.writeText "synapse-pg-init" ''
    CREATE DATABASE "matrix-synapse"
      WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = 'C'
      LC_CTYPE = 'C';
    '';
  };
}