# Istanbul - Music Stack

> [!summary] Purpose
> The music stack downloads and organizes music through a dedicated network namespace and WireGuard peer, while Navidrome serves the resulting library.

## Storage and identity

- The `music` system user and group own the stack's shared paths.
- Label `MUSIC` is mounted as ext4 at `/data/music` with `nofail`.
- `/data/music` is the final library directory (`02750`, `music:music`).
- `/tmp/music` is the download directory (`02770`, `music:music`).

## Services

| Service | Port | Key behavior |
| --- | ---: | --- |
| Navidrome | `4533` | Reads `/data/music`; data lives in `/var/lib/navidrome`; serves on `0.0.0.0` |
| Lidarr | `8686` | Runs as `music`; uses the isolated namespace |
| Prowlarr | `9696` | Uses the isolated namespace and namespace DNS config |
| FlareSolverr | `8191` | Uses the isolated namespace and namespace DNS config |
| qBittorrent | `8181` | Web UI and torrent traffic are bound to `wg0` |

All automation services are ordered after `netns-media-vpn` and `wireguard-wg0`. qBittorrent additionally receives the namespace path directly through systemd and writes the Lidarr category to `/tmp/music`.

## Namespace and VPN

The `media-vpn` namespace is connected to the host with a veth pair:

| Side | Interface | Address |
| --- | --- | --- |
| Host | `media-vpn-host` | `10.200.0.1/30` |
| Namespace | `media-vpn` | `10.200.0.2/30` |

The namespace gets dedicated resolvers through `/etc/netns/media-vpn/resolv.conf`. WireGuard `wg0` lives in the namespace, receives `10.2.0.2/32` and `2a07:b944::2:2/128`, and installs default IPv4 and IPv6 routes through its peer. The peer endpoint is `146.70.202.50:51820` with a 25-second keepalive.

> [!warning] Routing invariant
> qBittorrent is configured with `Interface = "wg0"` and `InterfaceAddress = "10.2.0.2"`. If the namespace or WireGuard unit fails, downloads should remain unavailable rather than silently leaving through the host's normal route; validate this invariant after network changes.

## Navidrome first login

The source sets a default administrator account for initial access and explicitly says to change it after first login. Treat that value as a bootstrap secret, not as a permanent credential, and do not repeat it in this wiki.

## Dependency checklist

- [x] `MUSIC` filesystem declared
- [x] `music` user/group declared
- [x] Namespace created before WireGuard
- [x] WireGuard required before VPN-bound services
- [x] Download category points to `/tmp/music`
- [ ] Add the planned Navidrome Prometheus endpoint (marked TODO in source)