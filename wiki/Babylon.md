#host/babylon #role/messaging #status/active

> [!abstract] Role
> Babylon hosts Matrix Synapse, its PostgreSQL database, and the static Synapse Admin interface. Istanbul provides public TLS ingress.

## Services

| Service | Status | Local endpoint | Note |
| --- | --- | --- | --- |
| [[Fleet Kmscon]] | Active | Local console | Console service |
| [[Fleet OpenSSH]] | Active | Host SSH | Administrative access |
| [[Babylon PostgreSQL]] | Active | Local database socket | Matrix database |
| [[Babylon Synapse]] | Active | `0.0.0.0:8008` | Matrix client and federation API |
| [[Babylon Synapse Admin]] | Active | `127.0.0.1:8080` | Static admin frontend via darkhttpd |
| [[Babylon Vector]] | Active | Vector API as configured | Logs and host metrics to Rome |

## Network

Babylon is `192.168.2.3/24`, with Istanbul as gateway and DNS. LAN TCP `22` and `8008`, plus UDP `3478`, are allowed. Public access is expected through `matrix.neekokun.com`; see [[Istanbul Nginx]].

## Matrix dependencies

Synapse uses PostgreSQL and references TURN at `turn.neekokun.com:3478` and `:3480`. Istanbul's Coturn module is currently disabled, so TURN-based calling is a configuration dependency that needs runtime validation.

## Change checklist

- [ ] Confirm database, Synapse, and admin imports remain enabled.
- [ ] Run `nixos-rebuild dry-build --flake .#babylon`.
- [ ] Validate Matrix client, federation, and TURN behavior after deployment.
