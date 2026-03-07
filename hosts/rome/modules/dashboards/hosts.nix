{ vars, ... }:

{
  # Hosts status dashboard
  environment.etc."grafana-dashboards/hosts-status.json" = {
    text = builtins.toJSON {
      annotations.list = [];
      editable = true;
      fiscalYearStartMonth = 0;
      graphTooltip = 0;
      id = null;
      links = [];
      panels = [
        {
          title = "CPU Usage by Host";
          datasource = {
            type = "prometheus";
            uid = "Prometheus";
          };
          fieldConfig = {
            defaults = {
              color.mode = "thresholds";
            };
          };
          gridPos = { h = 24; w = 6; x = 0; y = 0; };
          id = 1;
          targets = [
            {
              expr = "sum(rate(host_cpu_seconds_total{mode!=\"idle\"}[1m])) by (host) / sum(rate(host_cpu_seconds_total[1m])) by (host) * 100";
              legendFormat = "{{ hostname }}";
              refId = "A";
            }
          ];
          type = "gauge";
        }
      ];
      refresh = "30s";
      schemaVersion = 38;
      tags = [ "metrics" ];
      time = { from = "now-6h"; to = "now"; };
      title = "Multi-Host Status";
      uid = "multi-host-status";
      version = 0;
    };
  };

  # Host metrics dashboard
  environment.etc."grafana-dashboards/host-metrics.json" = {
    text = builtins.toJSON {
      annotations.list = [];
      editable = true;
      fiscalYearStartMonth = 0;
      graphTooltip = 0;
      id = null;
      links = [];
      panels = [
        {
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
          gridPos = { h = 8; w = 12; x = 0; y = 0; };
          id = 1;
          targets = [
            {
              expr = "sum(rate(host_cpu_seconds_total{mode!=\"idle\"}[1m])) by (host) / sum(rate(host_cpu_seconds_total[1m])) by (host) * 100";
              legendFormat = "{{hostname}}";
              refId = "A";
            }
          ];
          title = "CPU Usage by Host";
          type = "timeseries";
        }
        {
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
              expr = "(host_memory_total_bytes - host_memory_available_bytes) / host_memory_total_bytes * 100";
              legendFormat = "{{host}}";
              refId = "A";
            }
          ];
          title = "Memory Usage by Host";
          type = "timeseries";
        }
        {
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
          gridPos = { h = 8; w = 12; x = 0; y = 8; };
          id = 3;
          targets = [
            {
              expr = "rate(host_network_receive_bytes_total{device!=\"lo\"}[5m])";
              legendFormat = "{{host}} - {{device}} RX";
              refId = "A";
            }
          ];
          title = "Network Traffic Received by Host";
          type = "timeseries";
        }
        {
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
          gridPos = { h = 8; w = 12; x = 12; y = 8; };
          id = 4;
          targets = [
            {
              expr = "rate(host_network_transmit_bytes_total{device!=\"lo\"}[5m])";
              legendFormat = "{{host}} - {{device}}";
              refId = "A";
            }
          ];
          title = "Network Traffic Transmitted by Host";
          type = "timeseries";
        }
      ];
      refresh = "30s";
      schemaVersion = 38;
      tags = [ "metrics" ];
      time = { from = "now-6h"; to = "now"; };
      title = "Multi-Host Metrics";
      uid = "multi-host-metrics";
      version = 0;
    };
  };
}
