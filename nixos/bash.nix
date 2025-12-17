{ config, pkgs, vars, ... }:

{
  programs.bash = {
    enable = true;

    loginShellInit = ''
      if [ -z "$TMUX" ] && [ -n "KMSCON" ]; then
        exec tmux
      fi
    '';
  };

  environment.etc.inputrc.text = ''
    "\e[A": history-search-backward
    "\e[B": history-search-forward
  '';
}
