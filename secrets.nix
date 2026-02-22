{ config, lib, pkgs, vars, ... }:

{
  age = {
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      adminPassword = {
        file = ./secrets/admin-password.age;
      };
    };
  };
}
