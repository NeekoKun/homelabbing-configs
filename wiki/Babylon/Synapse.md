#service/synapse #host/babylon #status/active #area/messaging

> [!abstract] Purpose
> Synapse is the Matrix homeserver for `neekokun.com`.

## Configuration

- Listens on `0.0.0.0:8008`.
- Server name: `neekokun.com`.
- Public URL: `matrix.neekokun.com`.
- Client and federation resources are enabled.
- Registration is enabled but requires a token.
- Uses PostgreSQL through [[PostgreSQL]].

## TURN

TURN URIs reference `turn.neekokun.com:3478` and `:3480`. The shared secret is generated from `coturn-secret.age`; the configured TURN shared secret and registration secret remain literal TODO values and should be moved to age-managed inputs.

> [!warning] Current dependency gap
> [[Coturn]] is disabled, so Matrix calling and relay behavior are not confirmed by the evaluated configuration.

## Access

Istanbul Nginx proxies `matrix.neekokun.com` to `192.168.2.3:8008` and provides the domain's Matrix well-known responses.

[^source]: `hosts/babylon/modules/synapse.nix`, `hosts/istanbul/modules/nginx.nix`, `secrets/secrets.nix`
