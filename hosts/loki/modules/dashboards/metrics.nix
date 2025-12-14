{
  # Host metrics dashboard (now works with Vector metrics)
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
            uid = "prometheus";
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
                pointSize = 5;
                showPoints = "never";
                spanNulls = false;
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
              expr = "100 - (avg by (hostname) (irate(vector_host_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)";
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
            uid = "prometheus";
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
                pointSize = 5;
                showPoints = "never";
                spanNulls = false;
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
              expr = "(vector_host_memory_total_bytes - vector_host_memory_available_bytes) / vector_host_memory_total_bytes * 100";
              legendFormat = "{{hostname}}";
              refId = "A";
            }
          ];
          title = "Memory Usage by Host";
          type = "timeseries";
        }
        {
          datasource = {
            type = "prometheus";
            uid = "prometheus";
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
                pointSize = 5;
                showPoints = "never";
                spanNulls = false;
              };
              unit = "bytes";
            };
          };
          gridPos = { h = 8; w = 24; x = 0; y = 8; };
          id = 3;
          targets = [
            {
              expr = "rate(vector_host_network_receive_bytes_total{device!=\"lo\"}[5m])";
              legendFormat = "{{hostname}} - {{device}} RX";
              refId = "A";
            }
            {
              expr = "rate(vector_host_network_transmit_bytes_total{device!=\"lo\"}[5m])";
              legendFormat = "{{hostname}} - {{device}} TX";
              refId = "B";
            }
          ];
          title = "Network Traffic by Host";
          type = "timeseries";
        }
      ];
      refresh = "30s";
      schemaVersion = 38;
      tags = ["host" "metrics" "vector"];
      time = { from = "now-6h"; to = "now"; };
      title = "Multi-Host Metrics";
      uid = "multi-host-metrics";
      version = 0;
    };
  };
}