# Shared Configuration

## Flake model

`flake.nix` pins `nixpkgs` to `nixos-26.05` and declares agenix plus the external `myWiki` input. Each host is built by `mkHost` with:

1. `agenix.nixosModules.default`;
2. `configuration.nix`;
3. `hosts/<name>/default.nix`.

The four outputs are `istanbul`, `rome`, `babylon`, and `alexandria`, all targeting `x86_64-linux`.

## Shared variables

### Service ports

The flake centralizes ports for Prometheus (`9696`), Loki (`3100`/`9096`), Grafana (`2342`), Navidrome (`4533`), the music automation services, Synapse (`8008`), Coturn (`3478`/`3480`), and Vaultwarden (`8222`). Istanbul modules consume these values rather than duplicating most port numbers.

### Network identity

| Item | Value |
| --- | --- |
| Domain | `neekokun.com` |
| WAN interface | `enp0s20u3c2` |
| LAN interface | `enp0s3` |
| Internal subnet | `192.168.2.0/24` |
| Istanbul | `192.168.2.1` |
| Rome | `192.168.2.2` |
| Babylon | `192.168.2.3` |
| Alexandria | `192.168.2.4` |

The network namespace names are `media-vpn` and `media-vpn-host`.

> [!info] Naming detail
> The source variable is named `network.DNS`, with `domain = "neekokun"` and `tld = "com"`. Together these produce the public suffix `neekokun.com`.

## Base system

`configuration.nix` enables flakes, daily Nix garbage collection, weekly deletion of old system generations (keeping the five newest), systemd-boot, the Europe/Rome timezone, Italian console settings, and an immutable-user policy.

The shared package set includes shell and diagnostics tools such as `vim`, `git`, `tmux`, `python3`, `jq`, `dig`, `tcpdump`, `btop`, and `fastfetch`. `nixos/default.nix` imports `nixos/bash.nix`, which enables Bash and starts an attached `tmux` session for interactive SSH logins when available.

> [!warning] Review before production use
> The source currently contains development-looking account settings, including a plain password assignment and a commented `hashedPasswordFile`. Treat this as a configuration risk and verify the intended secret-backed login before deployment.