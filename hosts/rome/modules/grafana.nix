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

{ vars, ... }:

let
  net = vars.network;
in
{
  services.grafana = {
    enable = true;
    
    settings = {
      server = {
        http_addr = "${net.internal.rome}";
        http_port = vars.services.grafana.port;
        domain = "grafana.${net.DNS.domain}.${net.DNS.tld}";
        root_url = "https://grafana.${net.DNS.domain}.${net.DNS.tld}";
      };
    };
    
    provision = {
      enable = true;
      
      datasources.settings = {
        apiVersion = 1;
        datasources = [
          {
            name = "Loki";
            type = "loki";
            access = "proxy";
            url = "http://127.0.0.1:${toString vars.services.loki.http_port}";
            isDefault = false;
          }
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://127.0.0.1:${toString vars.services.prometheus.http_port}";
            isDefault = true;
          }
        ];
      };

      dashboards.settings = {
        apiVersion = 1;
        providers = [
          {
            name = "default";
            orgId = 1;
            folder = "";
            type = "file";
            disableDeletion = false;
            editable = true;
            options = {
              path = "/etc/grafana-dashboards";
            };
          }
        ];
      };
    };
  };

  imports = [ ./dashboards/default.nix ];
}
