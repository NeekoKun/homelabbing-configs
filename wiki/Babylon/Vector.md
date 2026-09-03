#service/vector #host/babylon #status/active #area/observability

> [!abstract] Purpose
> Vector forwards Babylon journald data and host metrics to Rome.

## Dependencies

Requires reachability to [[Prometheus]] and [[Loki]]. Matrix and PostgreSQL logs should remain identifiable in labels used by [[Dashboards]].

[^source]: `hosts/babylon/modules/vector.nix`, `hosts/rome/modules/prometheus.nix`, `hosts/rome/modules/loki.nix`
