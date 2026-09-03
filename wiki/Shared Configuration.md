#area/platform #status/active

> [!abstract] Source of truth
> The flake contains cross-host variables. See [[Shared Baseline]] for the common NixOS layer and the host notes for evaluated service imports.

## Flake variables

The public suffix is `neekokun.com`; the LAN is `192.168.2.0/24`.

| Host | Address | Role |
| --- | --- | --- |
| [[Istanbul]] | `192.168.2.1` | Gateway and ingress |
| [[Rome]] | `192.168.2.2` | Observability |
| [[Babylon]] | `192.168.2.3` | Matrix |
| [[Alexandria]] | `192.168.2.4` | Media and cloud |

WAN is `enp0s20u3c2`; LAN is `enp0s3`. The media namespace names are `media-vpn` and `media-vpn-host`.

## Central service ports

| Service | Port |
| --- | ---: |
| Prometheus | `9696` |
| Loki HTTP / gRPC | `3100` / `9096` |
| Grafana | `2342` |
| Navidrome | `4533` |
| FlareSolverr | `8191` |
| Prowlarr | `9696` |
| Lidarr | `8686` |
| qBittorrent | `8181` |
| Synapse | `8008` |
| Coturn | `3478` / `3480` |
| Vaultwarden | `8222` |

## Base system

[[Shared Baseline]] documents the common boot, users, packages, console, Bash/tmux, garbage collection, timezone, and state-version settings. [[Secret Inventory]] documents the agenix boundary.

> [!warning] Import boundary
> A module file is not active merely because it exists. Confirm each host's `modules/default.nix` before treating a service as deployed.