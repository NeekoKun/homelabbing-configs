{ config, lib, pkgs, vars, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 4343 ];

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };

    extraConfig = ''
      X11Forwarding no
      AllowAgentForwarding yes
      AllowTcpForwarding yes
    '';
  };
}