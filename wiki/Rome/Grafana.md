#service/grafana #host/rome #status/active #area/observability

> [!abstract] Purpose
> Grafana is the observability UI for metrics and logs, published through Istanbul.

## Configuration

- Listens on `192.168.2.2:2342`.
- Public domain: `grafana.neekokun.com`.
- Provisions Prometheus and Loki datasources.
- Imports dashboards from [[Dashboards]].

## Dependencies

Requires [[Prometheus]], [[Loki]], and Istanbul Nginx for public TLS ingress. Dashboard queries are configuration-level assumptions until verified against live data.

## Operations

```bash
journalctl -u grafana -n 50
```

[^source]: `hosts/rome/modules/grafana.nix`, `hosts/istanbul/modules/nginx.nix`
