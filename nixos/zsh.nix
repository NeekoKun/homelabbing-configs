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

{ pkgs, ... }:

{
    programs.zoxide = {
        enable = true;
    };

    programs.zsh = {
        enable = true;

        enableCompletion = true;
        autosuggestions = {
            enable = true;
        };
        syntaxHighlighting = {
            enable = true;
        };

        histSize = 5000;

        shellInit = ''
            zsh-newuser-install() { :; }
        '';
        loginShellInit = ''
            if [[ $- == *i* ]] && [[ -t 1 ]] && [ -z "$TMUX" ] && command -v tmux &>/dev/null && [ -n "$SSH_CONNECTION" ]; then
                exec tmux new-session -A -s main
            fi
        '';
        interactiveShellInit = ''
            # --- Kali-style two-line prompt ---
            typeset -g POWERLEVEL9K_MODE=ascii
            typeset -g POWERLEVEL9K_BACKGROUND=
            typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs newline prompt_char)
            typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs)

            # ┌──(user㉿host)-[~/path]-main
            # └─$
            typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='┌──'
            typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='└─'
            typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=
            typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='-'
            typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
            typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=

            typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='(%n㉿%m)'
            typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO,REMOTE,REMOTE_SUDO}_FOREGROUND=39
            typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=196
            typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
            typeset -g POWERLEVEL9K_DIR_FOREGROUND=252
            typeset -g POWERLEVEL9K_DIR_CONTENT_EXPANSION='[''${P9K_CONTENT}]'

            typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='$'
            typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='$'
            typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=39
            typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=196

            # Transient prompt: finished prompts collapse to just "└─$ command"
            typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        '';
    };

    environment = {
        systemPackages = [ pkgs.zsh-powerlevel10k ];

        etc.inputrc.text = ''
            "\e[A": history-search-backward
            "\e[B": history-search-forward
        '';
    };
}