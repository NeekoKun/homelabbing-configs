#area/security #status/active

> [!abstract] Purpose
> Agenix secrets provide credentials and private material without storing decrypted values in the repository.

## Inventory

| Secret | Consumers |
| --- | --- |
| `admin-password.age` | All hosts and admin |
| `cloudflare-env.age` | [[DDNS]] |
| `proton-private-key.age` | [[WireGuard]] |
| `maxmind-license-key.age` | [[GeoIP]] |
| `coturn-secret.age` | [[Coturn]], [[Synapse]] |
| `nextcloud-admin-password.age` | [[Nextcloud]] |
| `vaultwarden-env.age` | [[Vaultwarden]] |

> [!danger] Handling rule
> Document filenames, owners, and purpose only. Never place decrypted values in notes, logs, issues, or shell history.

## Change workflow

```bash
agenix -e secrets/<name>.age
nix flake check
```

[^source]: `secrets/secrets.nix`, `secrets/*.age`
