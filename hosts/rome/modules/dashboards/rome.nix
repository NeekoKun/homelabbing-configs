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
  ## Rome Metrics dashboard ##

  # This dashboard shows CPU, memory usage, network saturation percentage, network received and transmitted in LAN
  # and disk saturation percentage for Rome.
  environment.etc."grafana-dashboards/rome-metrics.json" = {
    text = builtins.toJSON {
      annotations.list = [];
      editable = true;
      fiscalYearStartMonth = 0;
      graphTooltip = 1;
      id = null;
      links = [];
      panels = [
        {
          title = "CPU Usage by Processor State";
          datasource = {
            type = "prometheus";
            uid = "Prometheus";
          };
          fieldConfig = {
            defaults = {
              color.mode = "palette-classic";
              custom = {
                axisCenteredZero = false;
                axisColorMode = "text";
                axisPlacement = "auto";
                drawStyle = "bars";
                stacking = {
                  group = "A";
                  mode = "normal";
                };
                fillOpacity = 10;
                lineInterpolation = "linear";
                lineWidth = 1;
                pointSize = 3;
                showPoints = "never";
                spanNulls = true;
                gradientMode = "hue";
              };
              max = 100;
              min = 0;
              unit = "percent";
            };
          };
          gridPos = { h = 8; w = 12; x = 0; y = 0; };
          id = 1;
          targets = [
            {
              expr = "sum(rate(host_cpu_seconds_total{mode=\"system\",host=\"rome\"}[1m])) / sum(rate(host_cpu_seconds_total{host=\"rome\"}[1m])) * 100";
              legendFormat = "System Mode";
              refId = "A";
            }
            {
              expr = "sum(rate(host_cpu_seconds_total{mode=\"user\",host=\"rome\"}[1m])) / sum(rate(host_cpu_seconds_total{host=\"rome\"}[1m])) * 100";
              legendFormat = "User Mode";
              refId = "B";
            }
            {
              expr = "sum(rate(host_cpu_seconds_total{mode=\"io_wait\",host=\"rome\"}[1m])) / sum(rate(host_cpu_seconds_total{host=\"rome\"}[1m])) * 100";
              legendFormat = "IO Wait";
              refId = "C";
            }
          ];
          type = "timeseries";
        }
        {
          title = "Memory Usage";
          datasource = {
            type = "prometheus";
            uid = "Prometheus";
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
                showPoints = "never";
                spanNulls = true;
                gradientMode = "hue";
              };
              min = 0;
              unit = "bytes";
            };
          };
          gridPos = { h = 8; w = 12; x = 12; y = 0; };
          id = 2;
          targets = [
            {
              expr = "(host_memory_total_bytes{host=\"rome\"} - host_memory_available_bytes{host=\"rome\"})";
              legendFormat = "Used Memory";
              refId = "A";
            }
            {
              expr = "host_memory_total_bytes{host=\"rome\"}";
              legendFormat = "Total Memory";
              refId = "B";
            }
          ];
          type = "timeseries";
        }
        {
          title = "Disk Usage";
          datasource = {
            type = "prometheus";
            uid = "Prometheus";
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
                showPoints = "never";
                spanNulls = true;
                gradientMode = "hue";
              };
              unit = "bytes";
            };
          };
          gridPos = { h = 8; w = 24; x = 0; y = 12; };
          id = 1;
          targets = [
            {
              expr = "host_filesystem_total_bytes{mountpoint=\"/\",host=\"rome\"}";
              legendFormat = "Total Space";
              refId = "A";
            }
            {
              expr = "host_filesystem_used_bytes{mountpoint=\"/\",host=\"rome\"}";
              legendFormat = "Used Space";
              refId = "B";
            }
          ];
          type = "timeseries";
        }
        {
          title = "Network Traffic Total";
          datasource = {
            type = "prometheus";
            uid = "Prometheus";
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
                showPoints = "never";
                spanNulls = true;
                gradientMode = "hue";
              };
              unit = "bytes";
            };
          };
          gridPos = { h = 8; w = 12; x = 0; y = 16; };
          id = 4;
          targets = [
            {
              expr = "rate(host_network_receive_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"rome\"}[5m])";
              legendFormat = "{{device}} - RX";
              refId = "A";
            }
            {
              expr = "rate(host_network_transmit_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"rome\"}[5m])";
              legendFormat = "{{device}} - TX";
              refId = "B";
            }
          ];
          type = "timeseries";
        }
        {
          title = "Network Traffic Percentage";
          datasource = {
            type = "prometheus";
            uid = "Prometheus";
          };
          fieldConfig = {
            defaults = {
              color.mode = "palette-classic";
              custom = {
                axisCenteredZero = false;
                axisColorMode = "text";
                axisPlacement = "auto";
                stacking = {
                  group = "A";
                  mode = "normal";
                };
                drawStyle = "line";
                fillOpacity = 10;
                lineInterpolation = "linear";
                lineWidth = 1;
                pointSize = 3;
                showPoints = "never";
                spanNulls = true;
                gradientMode = "hue";
                min = 0;
                max = 100;
              };
              unit = "percent";
            };
          };
          gridPos = { h = 8; w = 12; x = 12; y = 16; };
          id = 4;
          targets = [
            {
              expr = "rate(host_network_receive_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"rome\"}[5m])/(rate(host_network_receive_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"rome\"}[5m])+rate(host_network_transmit_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"rome\"}[5m])) * 100";
              legendFormat = "{{device}} - RX %";
              refId = "A";
            }
            {
              expr = "rate(host_network_transmit_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"rome\"}[5m])/(rate(host_network_receive_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"rome\"}[5m])+rate(host_network_transmit_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"rome\"}[5m])) * 100";
              legendFormat = "{{device}} - TX %";
              refId = "B";
            }
          ];
          type = "timeseries";
        }
      ];
      refresh = "30s";
      schemaVersion = 38;
      tags = [ "metrics" "rome" ];
      time = { from = "now-6h"; to = "now"; };
      title = "Rome Metrics";
      uid = "rome-metrics";
      version = 0;
    };
  };
}
