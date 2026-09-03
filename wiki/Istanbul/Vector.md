#service/vector #host/istanbul #status/disabled #area/observability

> [!abstract] Purpose
> Vector is prepared to ship Istanbul logs and metrics to Rome.

## Status

The module exists but is not imported on Istanbul. Nginx JSON access logs are already written to `/var/log/nginx/access.log`, and the prepared Vector configuration is therefore a future ingestion path.

## Reactivation checklist

- [ ] Import the module.
- [ ] Confirm Nginx log permissions and source paths.
- [ ] Validate destinations on [[Prometheus]] and [[Loki]].

[^source]: `hosts/istanbul/modules/vector.nix`, `hosts/istanbul/modules/default.nix`
