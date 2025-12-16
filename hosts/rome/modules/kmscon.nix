{ config, pkgs, vars, ... }:

let
  generateColors = color: import (pkgs.runCommand "console-colors.nix" {
    buildInputs = [ python3 ];
  } ''
    python3 ${./../../../colors.py} "${color}" > $out
  '');

  colors = generateColors "6A0025";
in
{
  services.kmscon.extraConfig = ''
    font-size = 12
    xkb-layout = it
    palette = custom
  '';
}
    
