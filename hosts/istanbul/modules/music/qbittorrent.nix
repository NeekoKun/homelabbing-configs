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

{ flakeRoot, config, pkgs, vars, ... }:

{
    services.qbittorrent = {
        enable = true;
        webuiPort = vars.services.qbittorrent.http_port;
        group = "music";

        serverConfig = {
            LegalNotice.Accepted = true;

            BitTorrent = {
                Session = {
                    Interface = "wg0";
                    InterfaceAddress = "10.2.0.2";
                    InterfaceName = "wg0";
                };
            };

            Preferences = {
                Connection = {
                    Interface = "wg0";
                };


                WebUI = {
                    Username = "admin";
                    Password_PBKDF2 = "@ByteArray(NHi5AAPykw4cOpJ4fctgEw==:9DLBx2tzfJavcnMtvZZBvkBtovlDmnTgyzM+S+bLkRoc3iih5l7MGLJu4+kXTgtL/523szRigVs+xLAtMSNlXA==)";
                };
            };
        };
    };

    environment.etc."qbittorrent/categories.json".text = builtins.toJSON {
        lidarr.save_path = "/tmp/music";
    };

    systemd.tmpfiles.rules = [
        "C /var/lib/qBittorrent/qBittorrent/config/categories.json - - - - /etc/qbittorrent/categories.json"
    ];

    systemd.services.qbittorrent = {
        requires = [ "wireguard-wg0.service" "netns-${vars.network.netns.media-isolated-vpn}.service" ];
        after = [ "wireguard-wg0.service" "netns-${vars.network.netns.media-isolated-vpn}.service" ];

        serviceConfig = {
            NetworkNamespacePath = "/run/netns/${vars.network.netns.media-isolated-vpn}";
        };
    };
}