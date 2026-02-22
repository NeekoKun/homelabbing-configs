{ config, ... }:

{
  age = {
    secrets = {
      adminPassword = {
        file = ./secrets/admin-password.age;
      };
    };
  };
}
