{ config, pkgs, ... }:

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
    '';
  };

  environment.variables = {
    TERM = "xterm-256color";
    COLORTERM = "truecolor";
  };
}
