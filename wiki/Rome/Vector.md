#service/vector #host/rome #status/active #area/observability

> [!abstract] Purpose
> Vector is Rome's ingestion and forwarding layer for journald and host metrics.

## Configuration

- Collects journald entries and host metrics.
- Sends metrics to [[Prometheus]].
- Sends logs to [[Loki]].
- Exposes an API on localhost `:8686`.

## Consumers

Agents on Alexandria and Babylon use the same observability destinations; Istanbul has a prepared but disabled Vector module.

[^source]: `hosts/rome/modules/vector.nix`, `hosts/alexandria/modules/vector.nix`, `hosts/babylon/modules/vector.nix`
