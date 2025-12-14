{ vars, ... }:

let
  net = vars.network;
in
{
  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_port = vars.services.grafana.port;
        http_addr = "${net.internal.loki}";

        domain = "grafana.${net.DNS.domain}.${net.DNS.tld}";
        root_url = "https://grafana.${net.DNS.domain}.${net.DNS.tld}/";
      };

      security = {
        admin_user = "admin";
        admin_password = "admin";
      };

      "auth.anonymous" = {
        enabled = false;
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
            disableDeletion = true;
            editable = true;
            options = {
              path = "/etc/grafana-dashboards";
            };
          }
        ];
      };
    };
  };

  environment.etc."grafana-dashboard/loki-logs.json" = {
    text = builtins.toJSON {
      annotations = {
        list = [];
      };
      editable = false;
      fisicalYearStartMonth = 0;
      graphTooltip = 0;
      id = null;
      links = [];
      liveNow = false;

      panels = [
        {
          id = 1;
          datasource = {
            type = "loki";
            uid = "loki";
          };
          gridPos = {
            h = 12;
            w = 24;
            x = 0;
            y = 0;
          };
          title = "Recent Logs";
          type = "logs";
          targets = [
            {
              expr = "{job=\"systemd-journal\"}";
              refId = "A";
            }
          ];
          options = {
            showTime = true;
            showLabels = true;
            showCommondLabels = false;
            wrapLogMessage = true;
            prettifyLogMessage = false;
            enableLogDetails = true;
            dedupStrategy = "none";
            sortOrder = "Descending";
          };
        }
        {
          id = 2;
          title = "Log Rate";
          type = "graph";
          gridPos = { h = 8; w = 24; x = 0; y = 12; };
          datasource = {
            type = "loki";
            uid = "loki";
          };
          targets = [
            {
              expr = "sum(rate({jobs=\"systemd-journal\"}[1m]))";
              refid = "A";
              legendFormat = "logs/sec";
            }
          ];
          yaxes = [
            { format = "short"; label = "logs/sec"; }
            { format = "short"; }
          ];
        }
        {
          id = 3;
          title = "Logs by Unit";
          type = "logs";
          gridPos = { h = 12; w = 24; x = 0; y = 20; };
          datasource = {
            type = "loki";
            uid = "loki";
          };
          targets = [
            {
             expr = "{jobs=\"systemd-journal\"} |= \"\"";
              refId = "A";
            }
          ];
          options = {
            showTime = true;
            showLabels = true;
            showCommonLabels = false;
            wrapLogMessage = true;
          };
        }
      ];
    };
    mode = "0644";
  };
}
