{ vars, ... }:

let
  net = vars.network;
in
{
  environment.etc."grafana-dashboards/nginx-metrics.json" = {
    text = builtins.toJSON {
      __inputs = [
        {
          name = "DS_PROMETHEUS";
          label = "Prometheus";
          description = "";
          type = "datasource";
          pluginId = "prometheus";
          pluginName = "Prometheus";
        }
      ];
      __elements = {};
      __requires = [
        {
          type = "panel";
          id = "bargauge";
          name = "Bar gauge";
          version = "";
        }
        {
          type = "grafana";
          id = "grafana";
          name = "Grafana";
          version = "11.5.2";
        }
        {
          type = "datasource";
          id = "prometheus";
          name = "Prometheus";
          version = "1.0.0";
        }
        {
          type = "panel";
          id = "timeseries";
          name = "Time series";
          version = "";
        }
      ];
      annotations.list = [
        {
          builtIn = 1;
          datasource = {
            type = "datasource";
            uid = "grafana";
          };
          enable = true;
          hide = true;
          iconColor = "rgba(0, 211, 255, 1)";
          name = "Annotations & Alerts";
          target = {
            limit = 100;
            matchAny = false;
            tags = [];
            type = "dashboard";
          };
          type = "dashboard";
        }
      ];
      description = "NGINX metrics with Prometheus for custom log parser. Vector example. Should also work with https://github.com/martin-helmich/prometheus-nginxlog-exporter\r\nDashboard is based on 15947.";
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
              color.mode = "continuous-GrYlRd";
              mappings = [];
              thresholds = {
                mode = "percentage";
                steps = [
                  {
                    color = "green";
                    value = null;
                  }
                  {
                    color = "red";
                    value = 5;
                  }
                ];
              };
              unit = "percent";
            };
            overrides = [];
          };
          gridPos = { h = 8; w = 11; x = 0; y = 0; };
          id = 12;
          options = {
            displayMode = "lcd";
            legend = {
              calcs = [];
              displayMode = "list";
              placement = "bottom";
              showLegend = false;
            };
            maxVizHeight = 300;
            minVizHeight = 16;
            minVizWidth = 8;
            namePlacement = "auto";
            orientation = "horizontal";
            reduceOptions = {
              calcs = [ "lastNotNull" ];
              fields = "";
              values = false;
            };
            showUnfilled = true;
            sizing = "auto";
            text = {};
            valueMode = "color";
          };
          pluginVersion = "11.5.2";
          targets = [
            {
              datasource = {
                type = "prometheus";
                uid = "Prometheus";
              };
              exemplar = true;
              expr = "sum(rate(nginx_http_response_count_total{status=~\"^2..\",instance=\"'\$host'\"}[\$__rate_interval])) / sum(rate(nginx_http_response_count_total{instance=\"'\$host'\"}[\$__rate_interval])) * 100";
              hide = false;
              interval = "";
              legendFormat = "2** status codes";
              refId = "C";
            }
            {
              datasource = {
                type = "prometheus";
                uid = "Prometheus";
              };
              exemplar = true;
              expr = "sum(rate(nginx_http_response_count_total{status=~\"^4..\",instance=\"'\$host'\"}[\$__rate_interval])) / sum(rate(nginx_http_response_count_total{instance=\"'\$host'\"}[\$__rate_interval])) * 100";
              interval = "";
              legendFormat = "4** status codes";
              refId = "A";
            }
            {
              datasource = {
                type = "prometheus";
                uid = "Prometheus";
              };
              exemplar = true;
              expr = "sum(rate(nginx_http_response_count_total{status=~\"^5..\",instance=\"'\$host'\"}[\$__rate_interval])) / sum(rate(nginx_http_response_count_total{instance=\"'\$host'\"}[\$__rate_interval])) * 100";
              hide = false;
              interval = "";
              legendFormat = "5** status codes";
              refId = "B";
            }
          ];
          title = "Percentage Ratio of status codes to all status codes";
          transparent = true;
          type = "bargauge";
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
                axisBorderShow = false;
                axisCenteredZero = false;
                axisColorMode = "text";
                axisLabel = "";
                axisPlacement = "auto";
                barAlignment = 0;
                barWidthFactor = 0.6;
                drawStyle = "line";
                fillOpacity = 10;
                gradientMode = "none";
                hideFrom = {
                  legend = false;
                  tooltip = false;
                  viz = false;
                };
                insertNulls = false;
                lineInterpolation = "linear";
                lineWidth = 4;
                pointSize = 5;
                scaleDistribution.type = "linear";
                showPoints = "never";
                spanNulls = false;
                stacking = {
                  group = "A";
                  mode = "none";
                };
                thresholdsStyle.mode = "off";
              };
              mappings = [];
              thresholds = {
                mode = "absolute";
                steps = [
                  {
                    color = "green";
                    value = null;
                  }
                  {
                    color = "red";
                    value = 80;
                  }
                ];
              };
              unit = "short";
            };
            overrides = [];
          };
          gridPos = { h = 7; w = 11; x = 11; y = 0; };
          id = 4;
          options = {
            alertThreshold = true;
            legend = {
              calcs = [];
              displayMode = "list";
              placement = "bottom";
              showLegend = true;
            };
            tooltip = {
              hideZeros = false;
              mode = "multi";
              sort = "none";
            };
          };
          pluginVersion = "11.5.2";
          targets = [
            {
              datasource = {
                type = "prometheus";
                uid = "Prometheus";
              };
              exemplar = true;
              expr = "sum(rate(nginx_http_response_time_seconds_count{instance=\"'\$host'\"}[\$__rate_interval])) by (method) or label_replace(sum(rate(nginx_http_response_time_seconds_count{instance=\"'\$host'\"}[\$__rate_interval])), \"method\", \"Total\", \"\", \"\")";
              format = "time_series";
              interval = "";
              intervalFactor = 1;
              legendFormat = "{{method}}";
              refId = "A";
            }
          ];
          title = "Requests per Second";
          type = "timeseries";
        }
        {
          datasource = {
            type = "prometheus";
            uid = "Prometheus";
          };
          description = "Response sizes in bytes";
          fieldConfig = {
            defaults = {
              color.mode = "palette-classic";
              custom = {
                axisBorderShow = false;
                axisCenteredZero = false;
                axisColorMode = "text";
                axisLabel = "";
                axisPlacement = "auto";
                barAlignment = 0;
                barWidthFactor = 0.6;
                drawStyle = "line";
                fillOpacity = 10;
                gradientMode = "none";
                hideFrom = {
                  legend = false;
                  tooltip = false;
                  viz = false;
                };
                insertNulls = false;
                lineInterpolation = "linear";
                lineWidth = 4;
                pointSize = 5;
                scaleDistribution.type = "linear";
                showPoints = "never";
                spanNulls = false;
                stacking = {
                  group = "A";
                  mode = "none";
                };
                thresholdsStyle.mode = "off";
              };
              mappings = [];
              thresholds = {
                mode = "absolute";
                steps = [
                  {
                    color = "green";
                    value = null;
                  }
                  {
                    color = "red";
                    value = 80;
                  }
                ];
              };
              unit = "short";
            };
            overrides = [];
          };
          gridPos = { h = 7; w = 11; x = 11; y = 7; };
          id = 8;
          options = {
            alertThreshold = true;
            legend = {
              calcs = [];
              displayMode = "list";
              placement = "bottom";
              showLegend = true;
            };
            tooltip = {
              hideZeros = false;
              mode = "multi";
              sort = "none";
            };
          };
          pluginVersion = "11.5.2";
          targets = [
            {
              datasource = {
                type = "prometheus";
                uid = "Prometheus";
              };
              exemplar = true;
              expr = "sum(rate(nginx_http_response_size_bytes{instance=\"'\$host'\"}[\$__rate_interval])) by (method) / 1024 or label_replace(sum(rate(nginx_http_response_size_bytes{instance=\"'\$host'\"}[\$__rate_interval])) / 1024, \"method\", \"Total\", \"\", \"\")";
              format = "time_series";
              interval = "";
              intervalFactor = 1;
              legendFormat = "{{method}}";
              refId = "A";
            }
          ];
          title = "HTTP Traffic (KB/s)";
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
                axisBorderShow = false;
                axisCenteredZero = false;
                axisColorMode = "text";
                axisLabel = "";
                axisPlacement = "auto";
                barAlignment = 0;
                barWidthFactor = 0.6;
                drawStyle = "line";
                fillOpacity = 21;
                gradientMode = "none";
                hideFrom = {
                  legend = false;
                  tooltip = false;
                  viz = false;
                };
                insertNulls = false;
                lineInterpolation = "linear";
                lineWidth = 4;
                pointSize = 5;
                scaleDistribution.type = "linear";
                showPoints = "auto";
                spanNulls = false;
                stacking = {
                  group = "A";
                  mode = "none";
                };
                thresholdsStyle.mode = "off";
              };
              mappings = [];
              thresholds = {
                mode = "absolute";
                steps = [
                  {
                    color = "green";
                    value = null;
                  }
                  {
                    color = "red";
                    value = 80;
                  }
                ];
              };
            };
            overrides = [];
          };
          gridPos = { h = 7; w = 11; x = 0; y = 8; };
          id = 2;
          options = {
            legend = {
              calcs = [];
              displayMode = "list";
              placement = "bottom";
              showLegend = true;
            };
            tooltip = {
              hideZeros = false;
              mode = "single";
              sort = "none";
            };
          };
          pluginVersion = "11.5.2";
          targets = [
            {
              datasource = {
                type = "prometheus";
                uid = "Prometheus";
              };
              exemplar = true;
              expr = "sum(rate(nginx_http_response_time_seconds_sum{instance=\"'\$host'\"}[\$__rate_interval])) by (method) / sum(rate(nginx_http_response_time_seconds_count{instance=\"'\$host'\"}[\$__rate_interval])) by (method)";
              format = "time_series";
              interval = "";
              intervalFactor = 1;
              legendFormat = "{{method}}";
              refId = "A";
            }
          ];
          title = "Average Response Time";
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
                axisBorderShow = false;
                axisCenteredZero = false;
                axisColorMode = "text";
                axisLabel = "";
                axisPlacement = "auto";
                barAlignment = 0;
                barWidthFactor = 0.6;
                drawStyle = "line";
                fillOpacity = 10;
                gradientMode = "none";
                hideFrom = {
                  legend = false;
                  tooltip = false;
                  viz = false;
                };
                insertNulls = false;
                lineInterpolation = "linear";
                lineWidth = 3;
                pointSize = 5;
                scaleDistribution.type = "linear";
                showPoints = "never";
                spanNulls = false;
                stacking = {
                  group = "A";
                  mode = "none";
                };
                thresholdsStyle.mode = "off";
              };
              mappings = [];
              thresholds = {
                mode = "absolute";
                steps = [
                  {
                    color = "green";
                    value = null;
                  }
                  {
                    color = "red";
                    value = 80;
                  }
                ];
              };
              unit = "short";
            };
            overrides = [];
          };
          gridPos = { h = 8; w = 11; x = 11; y = 14; };
          id = 10;
          options = {
            alertThreshold = true;
            legend = {
              calcs = [];
              displayMode = "list";
              placement = "bottom";
              showLegend = true;
            };
            tooltip = {
              hideZeros = false;
              mode = "multi";
              sort = "none";
            };
          };
          pluginVersion = "11.5.2";
          targets = [
            {
              datasource = {
                type = "prometheus";
                uid = "Prometheus";
              };
              exemplar = true;
              expr = "sum(rate(nginx_http_response_count_total{instance='\$host'}[1m])) by (status)";
              format = "time_series";
              interval = "";
              intervalFactor = 1;
              legendFormat = "";
              refId = "A";
            }
          ];
          title = "Status codes per second";
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
                axisBorderShow = false;
                axisCenteredZero = false;
                axisColorMode = "text";
                axisLabel = "";
                axisPlacement = "auto";
                barAlignment = 0;
                barWidthFactor = 0.6;
                drawStyle = "line";
                fillOpacity = 10;
                gradientMode = "none";
                hideFrom = {
                  legend = false;
                  tooltip = false;
                  viz = false;
                };
                insertNulls = false;
                lineInterpolation = "linear";
                lineWidth = 4;
                pointSize = 5;
                scaleDistribution.type = "linear";
                showPoints = "never";
                spanNulls = false;
                stacking = {
                  group = "A";
                  mode = "none";
                };
                thresholdsStyle.mode = "off";
              };
              mappings = [];
              thresholds = {
                mode = "absolute";
                steps = [
                  {
                    color = "green";
                    value = null;
                  }
                  {
                    color = "red";
                    value = 80;
                  }
                ];
              };
              unit = "short";
            };
            overrides = [];
          };
          gridPos = { h = 7; w = 11; x = 0; y = 15; };
          id = 6;
          options = {
            alertThreshold = true;
            legend = {
              calcs = [];
              displayMode = "list";
              placement = "bottom";
              showLegend = true;
            };
            tooltip = {
              hideZeros = false;
              mode = "multi";
              sort = "none";
            };
          };
          pluginVersion = "11.5.2";
          targets = [
            {
              datasource = {
                type = "prometheus";
                uid = "Prometheus";
              };
              exemplar = true;
              expr = "histogram_quantile(0.9, sum(rate(nginx_http_response_time_seconds_bucket{status=~\"2[0-9]*\",instance=~\"'\$host'\"}[\$__rate_interval])) by (method, le))";
              format = "time_series";
              interval = "";
              intervalFactor = 1;
              legendFormat = "{{method}}";
              refId = "A";
            }
          ];
          title = "Response time (90% quantile)";
          type = "timeseries";
        }
      ];
      refresh = "5s";
      schemaVersion = 40;
      tags = [];
      templating.list = [
        {
          current = {};
          datasource = {
            type = "prometheus";
            uid = "Prometheus";
          };
          definition = "label_values(nginx_http_response_count_total,instance)";
          includeAll = false;
          label = "Host:";
          name = "host";
          options = [];
          query = {
            query = "label_values(nginx_http_response_count_total,instance)";
            refId = "StandardVariableQuery";
          };
          refresh = 1;
          regex = "";
          sort = 1;
          type = "query";
        }
      ];
      time = { from = "now-15m"; to = "now"; };
      timepicker = {};
      timezone = "";
      title = "NGINX Logs";
      uid = "Qa1U27CTEb";
      version = 1;
      weekStart = "";
      gnetId = 23059;
    };
  };
}
