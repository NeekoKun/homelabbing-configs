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

{ pkgs, lib, config, flakeRoot, ... }:

let
    cfg = config.my.palette;
    osc = pkgs.runCommand "palette-osc" { } ''
        ${pkgs.python3}/bin/python3 ${flakeRoot}/colors.py "${cfg.base}" --osc > $out
    '';
in
{
    options.my.palette.base = lib.mkOption {
        type = lib.types.str;
        example = "#5e81ac";
    };

    config = {
        programs.zsh.interactiveShellInit = ''
            if [[ -n $SSH_CONNECTION ]]; then
                if [[ -n $TMUX ]]; then
                    printf '\ePtmux;'
                    sed 's/\x1b/\x1b\x1b/g' ${osc}
                    printf '\e\\'
                else
                    cat ${osc}
                    zshexit() { printf '\e]104\a' }
                fi
            fi
        '';

        programs.tmux = {
            extraConfig = ''
                set -g allow-passthrough on
            '';
        };
    };
}