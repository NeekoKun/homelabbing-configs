#host/alexandria #role/media #status/active

> [!abstract] Role
> Alexandria is the media and cloud host. It stores the Navidrome library, runs Nextcloud, and provides Vaultwarden behind Istanbul's reverse proxy.

## Services

| Service | Status | Local endpoint | Note |
| --- | --- | --- | --- |
| [[Fleet Kmscon]] | Active | Local console | Console service |
| [[Fleet OpenSSH]] | Active | Host SSH | Administrative access |
| [[Alexandria/Navidrome]] | Active | `0.0.0.0:4533` | Music playback from `/mnt/music` |
| [[Nextcloud]] | Active | HTTP `:80` | Cloud, calendar, contacts, tasks, and news |
| [[Vaultwarden]] | Active | `0.0.0.0:8222` | Password manager; signups disabled |
| [[Alexandria/Vector]] | Active | Vector API as configured | Logs and host metrics to Rome |

## Network

Alexandria is `192.168.2.4/24`, uses Istanbul (`192.168.2.1`) as gateway and DNS, and permits LAN SSH, HTTP, and Vaultwarden traffic. Istanbul publishes the public routes; see [[Nginx]] and [[Network Edge|Istanbul network]].

## Storage and dependencies

- `/dev/sdb` mounts at `/mnt/music` before Navidrome starts.
- Nextcloud depends on its PostgreSQL backend and the agenix-managed admin password.
- Vaultwarden reads its environment from an encrypted secret.
- Vector forwards observability data to [[Rome/Vector]], [[Prometheus]], and [[Loki]].

## Change checklist

- [ ] Confirm the target service is imported by `hosts/alexandria/modules/default.nix`.
- [ ] Run `nixos-rebuild dry-build --flake .#alexandria`.
- [ ] Check the storage mount and service logs after deployment.
