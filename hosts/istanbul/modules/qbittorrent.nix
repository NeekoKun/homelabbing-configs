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

{
    services.qbittorrent = {
        enable = true;
        webuiPort = vars.services.qbittorrent.http_port;
        group = "music";

        serverConfig = {
            LegalNotice.Accepted = true;

            Connections = {
                Interface = "wg0";
            }

            Preferences.WebUI = {
                Username = "admin";
                Password_PBKDF2 = "@ByteArray(NHi5AAPykw4cOpJ4fctgEw==:9DLBx2tzfJavcnMtvZZBvkBtovlDmnTgyzM+S+bLkRoc3iih5l7MGLJu4+kXTgtL/523szRigVs+xLAtMSNlXA==)";
            };

            Categories = {
                lidarr = "/tmp/music";
            }
        };
    };

    networking.wg-quick = {
        interfaces.wg0 = {
            configFile = "/etc/nixos/wireguard/wg0.conf";
        };
    };

    systemd.services.qbittorrent = {
        requires = [ "wg-quick-wg0.service" ];
        after = [ "wg-quick-wg0.service" ];
    };
}