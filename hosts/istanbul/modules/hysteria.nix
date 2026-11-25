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

let
    hysteriaConfigs = pkgs.writeText "hysteria-server.yaml" ''
        listen: :443

        tls:
            cert: /var/lib/hysteria/fullchain.pem
            key: /var/lib/hysteria/key.pem

        auth:
            type: password
            password: "*+G^!h~Ooj!4u9BchiMtQ%N#Nv0),GcS0@w1WP#2,|s<h8uE,~/mkp;t5u>e[VCE"

        masquerade:
            type: proxy
            proxy:
                url: http://127.0.0.1:4533
                rewriteHost: true

        # Optional: extra QUIC-handshake obfuscation against fingerprinting
        # obfs:
        #   type: salamander
        #   salamander:
        #     password: "mCJ(xBOQ5x8)YZc{F'$V-c)vUC)Jc`,3B3ytanG~R+iHHko%E)fnVg4_>ck1:S1J"
    '';
in
{
    users.users.hysteria = {
        isSystemUser = true;
        group = "hysteria";
    };
    users.groups.hysteria = {};

    systemd.services.hysteria = {
        description = "Hysteria2 server (Navidrome masquerade + ssh tunnel)";
        after = [ "network-online.target" "acme-navidrome.neekokun.com.service" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            ExecStartPre = pkgs.writeShellScript "hysteria-prep" ''
                install -m0600 -o hysteria -g hysteria /var/lib/acme/navidrome.neekokun.com/fullchain.pem /var/lib/hysteria/fullchain.pem
                install -m0600 -o hysteria -g hysteria /var/lib/acme/navidrome.neekokun.com/key.pem /var/lib/hysteria/key.pem
            '';
            ExecStart = "${pkgs.hysteria}/bin/hysteria server -c ${hysteriaConfigs}";
            User = "hysteria";
            Group = "hysteria";
            StateDirectory = "hysteria";
            AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
            Restart = "on-failure";
        };
    };

    networking.firewall.allowedUDPPorts = [
        443
    ];
}