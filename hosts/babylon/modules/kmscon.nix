# Copyright (C) 2026 NeekoKun
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

{ config, pkgs, vars, ... }:

let
  generateColors = params: import (pkgs.runCommand "console-colors.nix" {
    buildInputs = [ pkgs.python3 ];
  } ''
    python3 ${./../../../colors.py} ${params} > $out
  '');

  colors = generateColors "1fc9be";
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
    
