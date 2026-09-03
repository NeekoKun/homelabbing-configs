#area/overview #status/active

> [!abstract] In one sentence
> This repository is a declarative NixOS homelab configuration for a small multi-host environment: an edge gateway, media and cloud services, Matrix messaging, and observability.

## Host topology

The README describes four purpose-built hosts:

| Host | Role | Services named by the README |
| --- | --- | --- |
| `istanbul` | Network edge | Coturn, DDNS, Nginx, Suricata |
| `alexandria` | Media and cloud | Navidrome, Nextcloud, Vaultwarden |
| `babylon` | Messaging | Synapse, Synapse Admin, PostgreSQL |
| `rome` | Observability | Prometheus, Loki, Grafana, dashboards |

Only `istanbul` is expanded in this wiki. See [[Istanbul Network Edge|Istanbul]] for the current module reality: several README services exist as files but are disabled in the active import list.

## Repository layout

- `flake.nix` - inputs, shared variables, and the four `nixosConfigurations`.
- `configuration.nix` - machine-wide baseline: flakes, garbage collection, boot, users, packages, and state version.
- `hardware-configuration.nix` - generated hardware settings.
- `hosts/<name>/` - host networking and service modules.
- `nixos/` - shared modules, currently Bash configuration and its import file.
- `secrets/` - age-encrypted data and the recipient map in `secrets.nix`.
- `wiki/` - this Obsidian-compatible documentation set.

## Prerequisites and deployment

The README expects:

1. NixOS on the target machine.
2. SSH access to the target.
3. Age/agenix keys configured.
4. Nix flakes enabled.

```bash
# Validate without switching
nixos-rebuild dry-build --flake .#istanbul

# Local deployment
nixos-rebuild switch --flake .#istanbul

# Remote deployment
nixos-rebuild switch --flake .#istanbul --target-host user@istanbul
```

> [!warning] Secrets are inputs, not documentation fixtures
> Do not paste decrypted `.age` contents into notes, issues, logs, or shell history. The repository records filenames and recipients, not secret values.

## Service access

The README uses the `*.neekokun.com` domain shape for public service URLs. Istanbul's Nginx configuration currently provisions routes for the wiki, media, cloud, Matrix, Grafana, and the default site; see [[Istanbul Edge Services|Edge services]].

## Development loop

- [ ] Edit the relevant module.
- [ ] Run a `dry-build` for the target host.
- [ ] Inspect service logs with `journalctl -u service-name -n 50`.
- [ ] Deploy with `nixos-rebuild switch --flake`.
- [ ] Add a host module and import it from that host's `modules/default.nix` when introducing a new service.

> "The source of truth is the evaluated Nix configuration, not a screenshot of the running host."