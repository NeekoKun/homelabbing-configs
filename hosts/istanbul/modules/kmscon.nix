{ config, pkgs, vars, ... }:

let
  generateColors = color: import (pkgs.runCommand "console-colors.nix" {
    buildInputs = [ pkgs.python3 ];
  } ''
    python3 ${./../../../colors.py} ${color} > $out
  '');

  colors = generateColors "920B3";
in 
{
  services.kmscon.extraConfig = ''
    font-size = 12
    xkb-layout = it
    palette = custom
    palette-black = ${colors.color0}
    palette-red = ${colors.color1}
    palette-green = ${colors.color2}
    palette-yellow = ${colors.color3}
    palette-blue = ${colors.color4}
    palette-magenta = ${colors.color5}
    palette-cyan = ${colors.color6}
    palette-light-grey = ${colors.color7}
    palette-dark-grey = ${colors.color8}
    palette-light-red = ${colors.color9}
    palette-light-green = ${colors.color10}
    palette-light-yellow = ${colors.color11}
    palette-light-blue = ${colors.color12}
    palette-light-magenta = ${colors.color13}
    palette-light-cyan = ${colors.color14}
    palette-white = ${colors.color15}
  '';
}
    
