#service/prometheus #host/rome #status/active #area/observability

> [!abstract] Purpose
> Prometheus stores fleet metrics and accepts remote writes for the observability stack.

## Configuration

- Listens on `0.0.0.0:9696`.
- Remote-write receiver is enabled.
- Retention is 30 days.
- Includes custom disk-throughput recording rules.

## Dependencies

[[Rome/Vector]] sends host metrics. Grafana reads this service as a provisioned datasource. The firewall permits LAN access to `9696`.

## Operations

```bash
journalctl -u prometheus -n 50
curl http://192.168.2.2:9696/-/ready
```

[^source]: `hosts/rome/modules/prometheus.nix`, `hosts/rome/modules/vector.nix`
