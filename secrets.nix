{ config, lib, pkgs, vars, ... }:

{
  age = {
    secrets = {
      adminPassword = {
        file = ./secrets/admin-password.age;
      };
    };
  };
}
