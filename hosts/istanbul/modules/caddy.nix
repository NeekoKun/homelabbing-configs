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

{ pkgs, vars, ... }:

let
  net = vars.network;
in
{
  environment.systemPackages = with pkgs; [
    caddy
  ];

  services.caddy = {
    enable = true;
    email = "neekokun@proton.me";

    globalConfig = ''
      servers {
        metrics
      }
    '';

    logFormat = ''
      output file /var/log/caddy/caddy.log {
        mode 0640
      }
    '';

    virtualHosts."vaultwarden.${net.DNS.domain}.${net.DNS.tld}" = {
      extraConfig = ''
        tls internal
        reverse_proxy http://${vars.network.internal.alexandria}:${toString vars.services.vaultwarden.http_port} {
          header_up X-Real-IP {http.request.remote.host}
          header_up X-Forwarded-For {http.request.remote.host}
          header_up X-Forwarded-Proto {http.request.proto}
        }
      '';

      logFormat = ''
        output file /var/log/caddy/access-vaultwarden.log {
          mode 0640
        }
      '';
    };

    virtualHosts."nextcloud.${net.DNS.domain}.${net.DNS.tld}" = {
      extraConfig = ''
        tls internal
        reverse_proxy http://${vars.network.internal.alexandria} {
          header_up X-Real-IP {http.request.remote.host}
          header_up X-Forwarded-For {http.request.remote.host}
          header_up X-Forwarded-Proto {http.request.proto}
        }
      '';

      logFormat = ''
        output file /var/log/caddy/access-nextcloud.log {
          mode 0640
        }
      '';
    };

    virtualHosts."navidrome.${net.DNS.domain}.${net.DNS.tld}" = {
      extraConfig = ''
        tls internal
        reverse_proxy http://${vars.network.internal.alexandria}:${toString vars.services.navidrome.http_port}
      '';

      logFormat = ''
        output file /var/log/caddy/access-navidrome.log {
          mode 0640
        }
      '';
    };

    virtualHosts."grafana.${net.DNS.domain}.${net.DNS.tld}" = {
      extraConfig = ''
        tls internal
        reverse_proxy http://${vars.network.internal.rome}:${toString vars.services.grafana.port}
      '';

      logFormat = ''
        output file /var/log/caddy/access-grafana.log {
          mode 0640
        }
      '';
    };

    virtualHosts."matrix.${net.DNS.domain}.${net.DNS.tld}" = {
      extraConfig = ''
        reverse_proxy http://${vars.network.internal.babylon}:${toString vars.services.synapse.http_port} {
          header_up X-Forwarded-For {http.request.remote.host}
          header_up X-Forwarded-Proto {http.request.proto}
          header_up Host {http.request.host}
        }
      '';

      logFormat = ''
        output file /var/log/caddy/access-matrix.log {
          mode 0640
        }
      '';
    };

    virtualHosts."www.${net.DNS.domain}.${net.DNS.tld}" = {
      extraConfig = ''
        tls internal
        redir https://${net.DNS.domain}.${net.DNS.tld} permanent
      '';

      logFormat = ''
        output file /var/log/caddy/access-www.log {
          mode 0640
        }
      '';
    };

    virtualHosts."${net.DNS.domain}.${net.DNS.tld}" = {
      extraConfig = ''
        tls internal
        respond "'Sup?" 200

        handle /.well-known/matrix/server {
          header Content-Type application/json
          respond "{\"m.server\": \"matrix.${net.DNS.domain}.${net.DNS.tld}:443\"}" 200
        }

        handle /.well-known/matrix/client {
          header Content-Type application/json
          header Access-Control-Allow-Origin "*"
          respond "{\"m.homeserver\": {\"base_url\": \"https://matrix.${net.DNS.domain}.${net.DNS.tld}\"}}" 200
        }
      '';

      logFormat = ''
        output file /var/log/caddy/access-root.log {
          mode 0640
        }
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
