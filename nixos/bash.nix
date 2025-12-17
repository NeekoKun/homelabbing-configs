{ config, pkgs, vars, ... }:

{
  programs.bash = {
    enable = true;

    interactiveShellInit = "tmux";
  };

  environment.etc.inputrc.text = ''
    "\e[A": history-search-backward
    "\e[B": history-search-forward
  '';
}
