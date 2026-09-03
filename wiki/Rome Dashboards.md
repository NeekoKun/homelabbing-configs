#service/grafana-dashboards #host/rome #status/active #area/observability

> [!abstract] Purpose
> The dashboard module provisions the operational views used by Grafana.

## Inventory

Dashboards cover logs, hosts, Rome, Istanbul, Babylon, Alexandria, Nginx, and Fail2ban.

## Dependencies

The dashboards depend on labels and queries emitted by Vector and data stored in Prometheus and Loki. A dashboard can load successfully while still showing no data, so validate representative panels after pipeline changes.

[^source]: `hosts/rome/modules/dashboards/default.nix`, `hosts/rome/modules/dashboards/`
