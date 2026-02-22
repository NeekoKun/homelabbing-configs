{ config, lib, pkgs, vars, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 4343 ];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };
}