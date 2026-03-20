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
  environment.etc."grafana-dashboards/caddy-metrics.json" = {
    text = builtins.toJSON {
      annotations.list = [];
      description = "Caddy metrics with Loki for custom log parser.";
      editable = true;
      fiscalYearStartMonth = 0;
      graphTooltip = 1;
      links = [];
      panels = [
        {
          datasource = {
            type = "loki";
            uid = "Loki";
          };
          fieldConfig = {
            defaults = {
              color = {
                mode = "thresholds";
              };
              mappings = [

              ];
              max = 100;
              thresholds = {
                mode = "percentage";
                steps = [
                  {
                    color = "green";
                    value = 0;
                  }
                ];
              };
              unit = "percent";
            };
            overrides = [

            ];
          };
          gridPos = {
            h = 8;
            w = 11;
            x = 0;
            y = 0;
          };
          id = 12;
          options = {
            displayMode = "lcd";
            legend = {
              calcs = [

              ];
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
              calcs = [
                "lastNotNull"
              ];
              fields = "";
              values = false;
            };
            showUnfilled = true;
            sizing = "auto";
            text = {

            };
            valueMode = "color";
          };
          pluginVersion = "12.3.0";
          targets = [
            {
              datasource = {
                type = "loki";
                uid = "P8E80F9AEF21F6940";
              };
              direction = "backward";
              editorMode = "code";
              expr = "sum(rate({job="caddy"} | status=~"2.." [24h]))/sum(rate({job="caddy"}[24h])) * 100";
              hide = false;
              legendFormat = "2**";
              queryType = "range";
              refId = "A";
            }
            {
              datasource = {
                type = "loki";
                uid = "P8E80F9AEF21F6940";
              };
              direction = "backward";
              editorMode = "code";
              expr = "sum(rate({job="caddy"} | status=~"3.." [24h]))/sum(rate({job="caddy"}[24h])) * 100";
              hide = false;
              legendFormat = "3**";
              queryType = "range";
              refId = "B";
            }
            {
              datasource = {
                type = "loki";
                uid = "P8E80F9AEF21F6940";
              };
              direction = "backward";
              editorMode = "code";
              expr = "sum(rate({job="caddy"} | status=~"4.." [24h]))/sum(rate({job="caddy"}[24h])) * 100";
              hide = false;
              legendFormat = "4**";
              queryType = "range";
              refId = "C";
            }
            {
              datasource = {
                type = "loki";
                uid = "P8E80F9AEF21F6940";
              };
              direction = "backward";
              editorMode = "code";
              expr = "sum(rate({job="caddy"} | status=~"5.." [24h]))/sum(rate({job="caddy"}[24h])) * 100";
              hide = false;
              legendFormat = "5**";
              queryType = "range";
              refId = "D";
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
              expr = "sum(rate(nginx_http_response_time_seconds_count{instance=\"\$host\"}[\$__rate_interval])) by (method) or label_replace(sum(rate(nginx_http_response_time_seconds_count{instance=\"\$host\"}[\$__rate_interval])), \"method\", \"Total\", \"\", \"\")";
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
              expr = "sum(rate(nginx_http_response_size_bytes{instance=\"\$host\"}[\$__rate_interval])) by (method) / 1024 or label_replace(sum(rate(nginx_http_response_size_bytes{instance=\"\$host\"}[\$__rate_interval])) / 1024, \"method\", \"Total\", \"\", \"\")";
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
              expr = "sum(rate(nginx_http_response_time_seconds_sum{instance=\"\$host\"}[\$__rate_interval])) by (method) / sum(rate(nginx_http_response_time_seconds_count{instance=\"\$host\"}[\$__rate_interval])) by (method)";
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
              expr = "sum(rate(nginx_http_response_count_total{instance=\"\$host\"}[1m])) by (status)";
              format = "time_series";
              interval = "";
              intervalFactor = 1;
              legendFormat = "{{status}}";
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
              expr = "histogram_quantile(0.9, sum(rate(nginx_http_response_time_seconds_bucket{status=~\"2[0-9]*\",instance=~\"\$host\"}[\$__rate_interval])) by (method, le))";
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
      tags = [ "caddy" "istanbul" ];
      time = { from = "now-15m"; to = "now"; };
      title = "Caddy Metrics";
      uid = "caddy-metrics";
      version = 1;
    };
  };
}
