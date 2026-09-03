#service/coturn #host/istanbul #status/disabled #area/messaging

> [!abstract] Purpose
> Coturn is the planned TURN relay for Matrix voice and video traffic.

## Status

The module exists but is not imported by `hosts/istanbul/modules/default.nix`. Babylon Synapse still advertises TURN URIs, so calling behavior is unverified.

## Configuration

- Planned listener ports: `3478` and `3480`.
- Uses the broad UDP relay range opened by Istanbul's firewall.
- Uses an ACME certificate and `coturn-secret.age`.

## Reactivation checklist

- [ ] Import the module on Istanbul.
- [ ] Confirm certificate and secret ownership.
- [ ] Validate Babylon connectivity and relay allocation.
- [ ] Reassess the UDP firewall range.

[^source]: `hosts/istanbul/modules/coturn.nix`, `hosts/babylon/modules/synapse.nix`, `secrets/secrets.nix`
