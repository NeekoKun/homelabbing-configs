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

    virtualHosts."vaultwarden.${net.DNS.domain}.${net.DNS.tld}" = {
      extraConfig = ''
        tls internal
        reverse_proxy http://${vars.network.internal.alexandria}:${toString vars.services.vaultwarden.http_port} {
          header_up X-Real-IP {http.request.remote.host}
          header_up X-Forwarded-For {http.request.remote.host}
          header_up X-Forwarded-Proto {http.request.proto}
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
    };

    virtualHosts."navidrome.${net.DNS.domain}.${net.DNS.tld}" = {
      extraConfig = ''
        tls internal
        reverse_proxy http://${vars.network.internal.alexandria}:${toString vars.services.navidrome.http_port}
      '';
    };

    virtualHosts."grafana.${net.DNS.domain}.${net.DNS.tld}" = {
      extraConfig = ''
        tls internal
        reverse_proxy http://${vars.network.internal.rome}:${toString vars.services.grafana.port}
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
    };

    virtualHosts."www.${net.DNS.domain}.${net.DNS.tld}" = {
      extraConfig = ''
        tls internal
        redir https://${net.DNS.domain}.${net.DNS.tld} permanent
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
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
