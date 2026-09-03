#service/vector #host/babylon #status/active #area/observability

> [!abstract] Purpose
> Vector forwards Babylon journald data and host metrics to Rome.

## Dependencies

Requires reachability to [[Rome Prometheus]] and [[Rome Loki]]. Matrix and PostgreSQL logs should remain identifiable in labels used by [[Rome Dashboards]].

[^source]: `hosts/babylon/modules/vector.nix`, `hosts/rome/modules/prometheus.nix`, `hosts/rome/modules/loki.nix`
