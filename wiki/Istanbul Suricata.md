#service/suricata #host/istanbul #status/disabled #area/security

> [!abstract] Purpose
> Suricata is the planned WAN-facing intrusion detection service.

## Status

The module is present and configured for WAN inspection, but its import is commented out. It is not part of the evaluated Istanbul service set.

## Reactivation checklist

- [ ] Import the module and confirm the capture interface.
- [ ] Review rules, alert output, and resource cost.
- [ ] Connect alerts to the observability path if desired.
- [ ] Run a dry build and validate traffic inspection safely.

[^source]: `hosts/istanbul/modules/suricata.nix`, `hosts/istanbul/modules/default.nix`
