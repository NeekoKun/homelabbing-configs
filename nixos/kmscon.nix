{ config, pkgs, vars, ... }:

let
  generateColors = color: import (pkgs.runCommand "console-colors.nix" {
    buildInputs = [ pkgs.python3 ];
  } ''
    python3 ${../colors.py} "${color}" > $out
  '');

  colors = generateColors vars.colors.${config.networking.hostName};
in
{
  services.kmscon = {
    enable = true;
    hwRender = true;

    fonts = [{
      name = "Source Code Pro";
      package = pkgs.source-code-pro;
    }];

    extraConfig = ''
      font-size = 12
      xkb-layout = it
      palette = custom
      palette-black = ${colors.color0}
      palette-red = ${colors.color1}
    '';
  };

  environment.variables = {
    TERM = "xterm-256color";
    COLORTERM = "truecolor";
  };
}
