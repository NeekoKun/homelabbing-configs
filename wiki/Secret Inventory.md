#area/security #status/active

> [!abstract] Purpose
> Agenix secrets provide credentials and private material without storing decrypted values in the repository.

## Inventory

| Secret | Consumers |
| --- | --- |
| `admin-password.age` | All hosts and admin |
| `cloudflare-env.age` | [[Istanbul DDNS]] |
| `proton-private-key.age` | [[Istanbul WireGuard]] |
| `maxmind-license-key.age` | [[Istanbul GeoIP]] |
| `coturn-secret.age` | [[Istanbul Coturn]], [[Babylon Synapse]] |
| `nextcloud-admin-password.age` | [[Alexandria Nextcloud]] |
| `vaultwarden-env.age` | [[Alexandria Vaultwarden]] |

> [!danger] Handling rule
> Document filenames, owners, and purpose only. Never place decrypted values in notes, logs, issues, or shell history.

## Change workflow

```bash
agenix -e secrets/<name>.age
nix flake check
```

[^source]: `secrets/secrets.nix`, `secrets/*.age`
