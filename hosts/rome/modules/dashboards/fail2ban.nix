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

{
  ## Fail2ban Dashboard ##

  # This dashboard shows fail2ban banned IPs count and unbanned IPs count,
  # as well as a global heatmap of banned IPs by geolocation
  environment.etc."grafana-dashboards/fail2ban.json" = {
    text = builtins.toJSON {
      annotations.list = [];
      editable = true;
      fiscalYearStartMonth = 0;
      graphTooltip = 1;
      id = null;
      links = [];
      panels = [
        {
          title = "Banned IPs";
          datasource = {
            type = "loki";
            uid = "Loki";
          };
          fieldConfig = {
            defaults = {
              color.mode = "palette-classic";
              custom = {
                axisCenteredZero = false;
                axisColorMode = "text";
                axisPlacement = "auto";
                drawStyle = "line";
                fillOpacity = 10;
                lineInterpolation = "linear";
                lineWidth = 1;
                pointSize = 3;
                showPoints = "always";
                spanNulls = true;
                gradientMode = "hue";
              };
              unit = "none";
            };
          };
          gridPos = { h = 8; w = 19; x = 0; y = 0; };
          id = 1;
          targets = [
            {
              expr = "sum by (jail) (count_over_time({job=\"fail2ban\", host=\"istanbul\", action=\"ban\"} [$__auto]))";
              legendFormat = "{{ jail }}";
              refId = "A";
            }
          ];
          type = "timeseries";
        }
        {
          title = "Banned IPs gauge";
          datasource = {
            type = "loki";
            uid = "Loki";
          };
          fieldConfig = {
            defaults = {
              color.mode = "thresholds";
              unit = "none";
              min = 0;
              thresholds = {
                mode = "absolute";
                steps = [
                  { color = "green"; value = null; }
                  { color = "yellow"; value = 10; }
                  { color = "red"; value = 40; }
                ];
              };
              displayName = "Banned in the last 24h";
            };
          };
          gridPos = { h = 8; w = 5; x = 19; y = 0; };
          id = 2;
          targets = [
            {
              expr = "sum (count_over_time({job=\"fail2ban\", host=\"istanbul\", action=\"ban\"} [1d]))";
              legendFormat = "Banned IPs";
              refId = "A";
            }
          ];
          type = "gauge";
        }
        {
          title = "Unbanned IPs";
          datasource = {
            type = "loki";
            uid = "Loki";
          };
          fieldConfig = {
            defaults = {
              color.mode = "palette-classic";
              custom = {
                axisCenteredZero = false;
                axisColorMode = "text";
                axisPlacement = "auto";
                drawStyle = "line";
                fillOpacity = 10;
                lineInterpolation = "linear";
                lineWidth = 1;
                pointSize = 3;
                showPoints = "always";
                spanNulls = true;
                gradientMode = "hue";
              };
              unit = "none";
            };
          };
          gridPos = { h = 8; w = 19; x = 0; y = 8; };
          id = 3;
          targets = [
            {
              expr = "sum by (jail) (count_over_time({job=\"fail2ban\", host=\"istanbul\", action=\"unban\"} [$__auto]))";
              legendFormat = "{{ jail }}";
              refId = "A";
            }
          ];
          type = "timeseries";
        }
        {
          title = "Unbanned IPs gauge";
          datasource = {
            type = "loki";
            uid = "Loki";
          };
          fieldConfig = {
            defaults = {
              color.mode = "palette-classic";
              unit = "none";
              min = 0;
              displayName = "Unbanned in the last 24h";
            };
          };
          gridPos = { h = 8; w = 5; x = 19; y = 8; };
          id = 4;
          targets = [
            {
              expr = "sum (count_over_time({job=\"fail2ban\", host=\"istanbul\", action=\"unban\"} [1d]))";
              legendFormat = "Unbanned IPs";
              refId = "A";
            }
          ];
          type = "gauge";
        }
      ];
      refresh = "30s";
      schemaVersion = 38;
      tags = [ "fail2ban" "istanbul" ];
      time = { from = "now-6h"; to = "now"; };
      title = "Fail2ban Logs";
      uid = "fail2ban-logs";
      version = 0;
    };
  };
}
