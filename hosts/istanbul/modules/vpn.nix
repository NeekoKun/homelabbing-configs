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
    age.secrets.protonPrivateKey.file = "${flakeRoot}/secrets/proton-private-key.age";
    networking.wireguard.interfaces.wg0 = {
        interfaceNamespace = vars.network.netns.isolated-vpn;
        socketNamespace = "init";

        ips = [ "10.2.0.2/32" "2a07:b944::2:2/128" ];
        privateKeyFile = config.age.secrets.protonPrivateKey.path;

        peers = [{
            publicKey = "A+M+tGj1r0fwJ1zscj3t93XEaskJmxU8GFlGcSCukFc=";
            allowedIPs = [ "0.0.0.0/0" "::/0" ];
            endpoint = "79.127.160.244:51820";
            persistentKeepalive = 25;
        }];

        allowedIPsAsRoutes = true;
    };

    systemd.services.wireguard-wg0 = {
        requires = [ "netns-${vars.network.netns.isolated-vpn}.target" ];

        after = [ "netns-${vars.network.netns.isolated-vpn}.target" ];
    };
}