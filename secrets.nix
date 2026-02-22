{ config, lib, pkgs, vars, ... }:

{
  age = {
    secrets = {
      adminPassword = {
        file = ./secrets/admin-password.age;
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };
  };
}
