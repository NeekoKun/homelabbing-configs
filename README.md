# Homelabbing Configs

Declarative NixOS configurations for a multi-host homelab.

## Hosts

- `istanbul` - network edge, DNS, reverse proxy, DDNS, and media networking
- `alexandria` - media and cloud services
- `babylon` - Matrix messaging and PostgreSQL
- `rome` - Prometheus, Loki, Grafana, and dashboards

## Requirements

- NixOS with flakes enabled
- SSH access to the target host
- Age/agenix keys configured for encrypted secrets

## Deploy

```bash
# Validate a host configuration
nixos-rebuild dry-build --flake .#istanbul

# Deploy locally
nixos-rebuild switch --flake .#istanbul

# Deploy remotely
nixos-rebuild switch --flake .#istanbul --target-host user@hostname
```

Replace `istanbul` with `alexandria`, `babylon`, or `rome` as needed.

## Secrets

Encrypted secrets are stored in [`secrets/`](secrets/) and declared in [`secrets/secrets.nix`](secrets/secrets.nix). Edit an encrypted secret with:

```bash
agenix -e secrets/secret-name.age
```

Never commit decrypted secret values.

## Documentation

The detailed, Obsidian-compatible project wiki is available at:

**[wiki.neekokun.com](https://wiki.neekokun.com)**

The source notes are in [`wiki/`](wiki/).
