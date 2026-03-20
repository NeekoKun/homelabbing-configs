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
  environment.etc."grafana-dashboards/services/caddy-metrics.json" = {
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
                mode = "palette-classic";
              };
              mappings = [];
              max = 100;
              unit = "percent";
            };
            overrides = [];
          };
          gridPos = { h = 8; w = 12; x = 0; y = 0; };
          id = 1;
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
                uid = "Loki";
              };
              direction = "backward";
              editorMode = "code";
              expr = "sum(rate({job=\"caddy\"} | status=~\"1..\" [24h]))/sum(rate({job=\"caddy\"}[24h])) * 100";
              hide = false;
              legendFormat = "1**";
              queryType = "range";
              refId = "A";
            }
            {
              datasource = {
                type = "loki";
                uid = "Loki";
              };
              direction = "backward";
              editorMode = "code";
              expr = "sum(rate({job=\"caddy\"} | status=~\"2..\" [24h]))/sum(rate({job=\"caddy\"}[24h])) * 100";
              hide = false;
              legendFormat = "2**";
              queryType = "range";
              refId = "B";
            }
            {
              datasource = {
                type = "loki";
                uid = "Loki";
              };
              direction = "backward";
              editorMode = "code";
              expr = "sum(rate({job=\"caddy\"} | status=~\"3..\" [24h]))/sum(rate({job=\"caddy\"}[24h])) * 100";
              hide = false;
              legendFormat = "3**";
              queryType = "range";
              refId = "C";
            }
            {
              datasource = {
                type = "loki";
                uid = "Loki";
              };
              direction = "backward";
              editorMode = "code";
              expr = "sum(rate({job=\"caddy\"} | status=~\"4..\" [24h]))/sum(rate({job=\"caddy\"}[24h])) * 100";
              hide = false;
              legendFormat = "4**";
              queryType = "range";
              refId = "D";
            }
            {
              datasource = {
                type = "loki";
                uid = "Loki";
              };
              direction = "backward";
              editorMode = "code";
              expr = "sum(rate({job=\"caddy\"} | status=~\"5..\" [24h]))/sum(rate({job=\"caddy\"}[24h])) * 100";
              hide = false;
              legendFormat = "5**";
              queryType = "range";
              refId = "E";
            }
          ];
          title = "Percentage Ratio of status codes (24h)";
          transparent = true;
          type = "bargauge";
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
