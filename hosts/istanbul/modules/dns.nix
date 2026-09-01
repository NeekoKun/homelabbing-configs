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

{ config, vars, pkgs, ... }:

{
    services.coredns = {
        enable = true;

        config = "
            home.arpa.:53 {
                hosts {
                    192.168.1.60 server.home.arpa
                    fallthrough
                }
            }

            station.:53 {
                hosts {
                    192.168.1.1 vodafone.station
                }
            }

            .:53 {

                hosts /var/lib/coredns/ad-blocklist.hosts {
                    reload 5m
                    fallthrough
                }

                forward . https://1.1.1.1 {
                    tls_servername cloudflare-dns.com
                }

                cache
            }
        ";
    };

    systemd.services.coredns = {
        preStart = "${pkgs.coreutils}/bin/touch /var/lib/coredns/ad-blocklist.hosts";
        serviceConfig = {
            ReadWritePaths = [ "/var/lib/coredns" ];
            StateDirectory = "coredns";
        };
    };

    systemd.services.fetch-ad-blocklist = {
        enable = true;
        description = "Fetch ad-blocklist for CoreDNS from https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        after = [ "network.target" ];
        requires = [ "network.target" ];
        before = [ "coredns.service" ];
        serviceConfig = {
            Type = "oneshot";
            User = "coredns";
            Group = "coredns";
            ExecStart = pkgs.writeShellScript "fetch-blocklist" ''
                set -euo pipefail
                tmp=$(mktemp)
                ${pkgs.curl}/bin/curl -sf https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts -o "$tmp"
                
                # sanity check: real list is >100KB and starts with a comment or 0.0.0.0 entry
                if [ -s "$tmp" ] && [ $(wc -l < "$tmp") -gt 1000 ]; then
                    grep -E '^0\.0\.0\.0 ' "$tmp" > /var/lib/coredns/ad-blocklist.hosts
                else
                    echo "Downloaded file looks invalid, keeping old list" >&2
                    rm -f "$tmp"
                    exit 1
                fi
            '';
            StateDirectory = "coredns";
            StateDirectoryMode = "0750";
            Restart = "on-failure";
            RestartSec = "30s";
        };
    };

    systemd.timers.fetch-ad-blocklist = {
        enable = true;
        description = "Fetch ad-blocklist for CoreDNS from https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        wantedBy = [ "timers.target" ];
        timerConfig = {
            OnCalendar = "*:0/30";
            Persistent = true;
            Unit = "fetch-ad-blocklist.service";
        };
    };
}