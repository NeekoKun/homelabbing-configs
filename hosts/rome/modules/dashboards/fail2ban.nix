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
                showPoints = "never";
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
              expr = "count_over_time({job=\"fail2ban\", host=\"istanbul\"} |~ \"Ban\" [$__auto])";
              legendFormat = "Banned IPs";
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
              color.mode = "palette-classic";
              unit = "none";
            };
          };
          gridPos = { h = 8; w = 5; x = 19; y = 0; };
          id = 2;
          targets = [
            {
              expr = "count_over_time({job=\"fail2ban\", host=\"istanbul\"} |~ \"Ban\" [$__auto])";
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
                showPoints = "never";
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
              expr = "count_over_time({job=\"fail2ban\", host=\"istanbul\"} |~ \"Unban\" [$__auto])";
              legendFormat = "Unbanned IPs";
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
            };
          };
          gridPos = { h = 8; w = 5; x = 19; y = 8; };
          id = 4;
          targets = [
            {
              expr = "count_over_time({job=\"fail2ban\", host=\"istanbul\"} |~ \"Unban\" [$__auto])";
              legendFormat = "Unbanned IPs";
              refId = "A";
            }
          ];
          type = "gauge";
        }
      ];
      refresh = "30s";
      schemaVersion = 38;
      tags = [ "metrics" "fail2ban" "istanbul" ];
      time = { from = "now-6h"; to = "now"; };
      title = "Fail2ban Metrics";
      uid = "fail2ban-metrics";
      version = 0;
    };
  };
}
