{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    user = {
      name = "Neeko";
      email = "neekokun@proton.me";
    };
  };
}
