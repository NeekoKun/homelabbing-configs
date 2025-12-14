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
            isDefault = false;
          }
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://127.0.0.1:${toString vars.services.prometheus.http_port}";
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

  imports = [ ./dashboards/default.nix ];
}
