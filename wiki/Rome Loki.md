#service/loki #host/rome #status/active #area/observability

> [!abstract] Purpose
> Loki stores centralized logs for the homelab.

## Configuration

- HTTP API on `:3100`.
- gRPC on `:9096`.
- Filesystem storage under `/var/lib/loki`.
- Single-node deployment with an in-memory ring.
- Rejects samples older than 168 hours.

## Dependencies

[[Rome Vector]] sends journald logs. Grafana reads Loki as a provisioned datasource. Disk capacity under `/var/lib/loki` is the primary persistence concern.

[^source]: `hosts/rome/modules/loki.nix`, `hosts/rome/modules/grafana.nix`
