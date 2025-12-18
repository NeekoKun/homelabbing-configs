{ vars, ... }:

{
  ## Rome Metrics dashboard ##

  # This dashboard shows CPU, memory usage, network saturation percentage, network received and transmitted in LAN
  # and disk saturation percentage for Rome.
  environment.etc."grafana-dashboards/istanbul-metrics.json" = {
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
              expr = "sum(rate(host_cpu_seconds_total{mode=\"system\",host=\"istanbul\"}[1m])) / sum(rate(host_cpu_seconds_total{host=\"istanbul\"}[1m])) * 100";
              legendFormat = "System Mode";
              refId = "A";
            }
            {
              expr = "sum(rate(host_cpu_seconds_total{mode=\"user\",host=\"istanbul\"}[1m])) / sum(rate(host_cpu_seconds_total{host=\"istanbul\"}[1m])) * 100";
              legendFormat = "User Mode";
              refId = "B";
            }
            {
              expr = "sum(rate(host_cpu_seconds_total{mode=\"io_wait\",host=\"istanbul\"}[1m])) / sum(rate(host_cpu_seconds_total{host=\"istanbul\"}[1m])) * 100";
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
              max = 100;
              min = 0;
              unit = "percent";
            };
          };
          gridPos = { h = 8; w = 12; x = 12; y = 0; };
          id = 2;
          targets = [
            {
              expr = "(host_memory_total_bytes{host=\"istanbul\"} - host_memory_available_bytes{host=\"istanbul\"}) / host_memory_total_bytes{host=\"istanbul\"} * 100";
              #legendFormat = "{{host}}";
              refId = "A";
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
          gridPos = { h = 8; w = 24; x = 0; y = 8; };
          id = 1;
          targets = [
            {
              expr = "host_filesystem_total_bytes{mountpoint=\"/\",host=\"istanbul\"}";
              legendFormat = "Total Space";
              refId = "A";
            }
            {
              expr = "host_filesystem_used_bytes{mountpoint=\"/\",host=\"istanbul\"}";
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
              expr = "rate(host_network_receive_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"istanbul\"}[5m])";
              legendFormat = "{{device}} - RX";
              refId = "A";
            }
            {
              expr = "rate(host_network_transmit_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"istanbul\"}[5m])";
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
              expr = "rate(host_network_receive_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"istanbul\"}[5m])/(rate(host_network_receive_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"istanbul\"}[5m])+rate(host_network_transmit_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"istanbul\"}[5m]))";
              legendFormat = "{{device}} - RX %";
              refId = "A";
            }
            {
              expr = "rate(host_network_transmit_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"istanbul\"}[5m])/(rate(host_network_receive_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"istanbul\"}[5m])+rate(host_network_transmit_bytes_total{device=\"${vars.network.interfaces.lan}\",host=\"istanbul\"}[5m]))";
              legendFormat = "{{device}} - TX %";
              refId = "B";
            }
          ];
          type = "timeseries";
        }
        {
          title = "Network Saturation by Host";
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
          gridPos = { h = 8; w = 24; x = 0; y = 24; };
          id = 1;
          targets = [
            {
              expr = "rate(host_network_transmit_bytes_total{host!=\"istanbul\",device=\"enp0s3\"}[1m]) / ignoring(host) group_left rate(host_network_receive_bytes_total{host=\"istanbul\",device=\"enp0s3\"}[1m])";
              legendFormat = "{{host}}";
              refId = "A";
            }
          ];
          type = "timeseries";
        }
      ];
      refresh = "30s";
      schemaVersion = 38;
      tags = [ "metrics" "istanbul" ];
      time = { from = "now-6h"; to = "now"; };
      title = "Istanbul Metrics";
      uid = "istanbul-metrics";
      version = 0;
    };
  };
}
