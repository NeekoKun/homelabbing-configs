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
    services.flaresolverr = {
        enable = true;
        port = vars.services.flaresolverr.http_port;
    };

    systemd.services.flaresolverr = {
        requires = [ "wireguard-wg0.service" "netns-${vars.network.netns.media-isolated-vpn}.service" ];
        after = [ "wireguard-wg0.service" "netns-${vars.network.netns.media-isolated-vpn}.service" ];

        serviceConfig = {
            NetworkNamespacePath = "/run/netns/${vars.network.netns.media-isolated-vpn}";

            BindReadOnlyPaths = [
                "/etc/netns/${vars.network.netns.media-isolated-vpn}/resolv.conf:/etc/resolv.conf"
            ];
            
            InaccessiblePaths = [
                "-/run/systemd/resolve" # Block resolved
                "-/run/nscd"            # Block nscd
                "-/var/run/nscd"        # Block nscd - usuallly a symlink to /run/nscd
            ];
        };
    };
}