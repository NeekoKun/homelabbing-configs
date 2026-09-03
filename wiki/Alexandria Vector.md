#service/vector #host/alexandria #status/active #area/observability

> [!abstract] Purpose
> Vector forwards Alexandria journald data and host metrics to Rome.

## Configuration

The module is active with the host's standard Vector pipeline. Destinations are the Rome Prometheus and Loki services.

## Dependencies

Requires network reachability to [[Rome Prometheus]] and [[Rome Loki]]. Changes to ports or labels should be checked against Rome dashboards.

[^source]: `hosts/alexandria/modules/vector.nix`, `hosts/rome/modules/prometheus.nix`, `hosts/rome/modules/loki.nix`
