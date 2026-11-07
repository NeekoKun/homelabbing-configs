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

{ config, ...}:

let
  psql    = "${config.services.postgresql.package}/bin/psql";
  doveadm = "${config.services.dovecot2.package}/bin/doveadm";
  runuser = "${pkgs.util-linux}/bin/runuser";
  mailuser = pkgs.writeShellScriptBin "mailuser" ''
    set -eu
    cmd="''${1:-}"; addr="''${2:-}"
    case "$cmd" in add|passwd) ;; *) echo "usage: mailuser add|passwd user@domain" >&2; exit 1 ;; esac
    case "$addr" in *@*) ;; *) echo "need user@domain" >&2; exit 1 ;; esac
    user="''${addr%@*}"; domain="''${addr#*@}"
    hash="$(${doveadm} pw -s ARGON2ID)"
    if [ "$cmd" = add ]; then
      sql="INSERT INTO users (localpart, domain, password_hash) VALUES (:'u', :'d', :'h');"
    else
      sql="UPDATE users SET password_hash = :'h' WHERE localpart = :'u' AND domain = :'d';"
    fi
    printf '%s\n' "$sql" | ${runuser} -u postgres -- ${psql} -X -v ON_ERROR_STOP=1 \
      -v "u=$user" -v "d=$domain" -v "h=$hash" mail
  '';
in
{
  environment.systemPackages = [ mailuser ];
}