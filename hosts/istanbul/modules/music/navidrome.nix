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

{ config, vars, ... }:

{
    services.navidrome = {
        enable = true;

        settings = {
            MusicFolder = "/data/music";
            DataFolder = "/var/lib/navidrome";
            Address = "0.0.0.0";
            Port = vars.services.navidrome.http_port;

            EnableCoverAnimation = true;
            EnableStarRating = true;
            EnableUserEditing = true;

            ND_DEFAULTADMIN_USERNAME = "admin";
            ND_DEFAULTADMIN_PASSWORD = "1234"; # Change this password once logged in for the first time
        }; #TODO: add Prometheus endpoint
    };

    systemd.services.navidrome = {
        serviceConfig.SupplementaryGroups = [ "music" ];
        after = [ "data-music.mount" ];
        requires = [ "data-music.mount" ];
    };

    services.nginx.virtualHosts = {
        "navidrome.${vars.network.DNS.domain}.${vars.network.DNS.tld}" = config.my.nginx.commonVHost // {
            http2 = true;
            http3 = true;
            quic = true;
            reuseport = true;

            extraConfig = ''
                add_header Alt-Svc 'h3=":443"; ma=86400' always;
            '';

            locations."/" = {
                    proxyPass = "http://127.0.0.1:${toString vars.services.navidrome.http_port}/";
            };
        };
    };

    networking.firewall.allowedUDPPorts = [
        443 # QUIC
    ];
}
