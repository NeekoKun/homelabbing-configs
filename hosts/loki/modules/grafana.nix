{ vars, ... }:

let
  net = vars.network;
in
{
  services.grafana = {
    enable = true;
    
    settings = {
      server = {
        http_addr = "${net.internal.loki}";
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

  # Create a properly formatted dashboard
  environment.etc."grafana-dashboards/loki-logs.json" = {
    text = builtins.toJSON {
      annotations = {
        list = [];
      };
      editable = false;
      fiscalYearStartMonth = 0;
      graphTooltip = 0;
      id = null;
      links = [];
      liveNow = false;
      panels = [
        {
          datasource = {
            type = "loki";
            uid = "Loki";
          };
          gridPos = {
            h = 12;
            w = 24;
            x = 0;
            y = 0;
          };
          id = 1;
          options = {
            dedupStrategy = "none";
            enableLogDetails = true;
            prettifyLogMessage = false;
            showCommonLabels = false;
            showLabels = true;
            showTime = true;
            sortOrder = "Descending";
            wrapLogMessage = true;
          };
          targets = [
            {
              datasource = {
                type = "loki";
                uid = "Loki";
              };
              editorMode = "code";
              expr = "{job=\"vector\"}";
              queryType = "range";
              refId = "A";
            }
          ];
          title = "Recent Logs";
          type = "logs";
        }
        {
          datasource = {
            type = "loki";
            uid = "Loki";
          };
          fieldConfig = {
            defaults = {
              color = {
                mode = "palette-classic";
              };
              custom = {
                axisCenteredZero = false;
                axisColorMode = "text";
                axisLabel = "";
                axisPlacement = "auto";
                barAlignment = 0;
                drawStyle = "line";
                fillOpacity = 10;
                gradientMode = "none";
                hideFrom = {
                  tooltip = false;
                  viz = false;
                  legend = false;
                };
                lineInterpolation = "linear";
                lineWidth = 1;
                pointSize = 5;
                scaleDistribution = {
                  type = "linear";
                };
                showPoints = "never";
                spanNulls = false;
                stacking = {
                  group = "A";
                  mode = "none";
                };
                thresholdsStyle = {
                  mode = "off";
                };
              };
              mappings = [];
              thresholds = {
                mode = "absolute";
                steps = [
                  {
                    color = "green";
                    value = null;
                  }
                ];
              };
              unit = "short";
            };
            overrides = [];
          };
          gridPos = {
            h = 8;
            w = 24;
            x = 0;
            y = 12;
          };
          id = 2;
          options = {
            legend = {
              calcs = [];
              displayMode = "list";
              placement = "bottom";
              showLegend = true;
            };
            tooltip = {
              mode = "single";
              sort = "none";
            };
          };
          targets = [
            {
              datasource = {
                type = "loki";
                uid = "Loki";
              };
              editorMode = "code";
              expr = "sum(count_over_time({job=\"vector\"}[1m]))";
              queryType = "range";
              refId = "A";
            }
          ];
          title = "Log Volume";
          type = "timeseries";
        }
      ];
      refresh = "30s";
      schemaVersion = 38;
      style = "dark";
      tags = ["loki" "logs"];
      templating = {
        list = [];
      };
      time = {
        from = "now-6h";
        to = "now";
      };
      timepicker = {};
      timezone = "";
      title = "System Logs";
      uid = "loki-vector-logs";
      version = 0;
      weekStart = "";
    };
  };
}
