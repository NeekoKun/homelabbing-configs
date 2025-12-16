{ config, pkgs, vars, ... }:

{
  services.kmscon.extraConfig = ''
    font-size = 12
    xkb-layout = it
    palette = custom
    palette-black = 68,0,106
    palette-red = 95,0,106
    palette-green = 106,0,90
    palette-yellow = 106,0,63
    palette-blue = 106,0,37
    palette-magenta = 106,0,10
    palette-cyan = 106,15,0
    palette-light-gray = 106,42,0
    palette-dark-gray = 37,0,53
    palette-light-red = 47,0,53
    palette-light-green = 53,0,45
    palette-light-yellow = 53,0,31
    palette-light-blue = 53,0,18
    palette-light-magenta = 53,0,5
    palette-light-cyan = 53,7,0
    palette-white = 53,21,0
  '';
}
    
