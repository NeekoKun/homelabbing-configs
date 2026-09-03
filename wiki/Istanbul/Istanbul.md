#host/istanbul #role/edge #status/active

> [!abstract] Role
> Istanbul is the LAN gateway, DNS resolver, public ingress point, and isolated egress host for the music automation stack.

## Services

| Service | Status | Note |
| --- | --- | --- |
| [[Network]] | Active | Forwarding, NAT, and firewall |
| [[CoreDNS]] | Active | LAN DNS and ad blocking |
| [[Nginx]] | Active | TLS ingress and reverse proxy |
| [[DDNS]] | Active | Cloudflare address updates |
| [[GeoIP]] | Active | GeoLite2 database updates |
| [[OpenSSH]] | Active | Local SSH endpoint |
| [[SSH-over-TLS]] | Active | Public SSH/TLS multiplexer |
| [[Music Namespace]] | Active | Isolated media network |
| [[WireGuard]] | Active | VPN egress for automation |
| [[Istanbul/Navidrome]] | Active | Music playback |
| [[Lidarr]] | Active | Music organization |
| [[Prowlarr]] | Active | Indexer management |
| [[FlareSolverr]] | Active | Challenge solving helper |
| [[qBittorrent]] | Active | VPN-bound downloads |
| [[Coturn]] | Disabled | Planned TURN relay |
| [[Suricata]] | Disabled | Planned WAN IDS |
| [[Istanbul/Vector]] | Disabled | Prepared log pipeline |

## Network

Istanbul is `192.168.2.1/24` on `enp0s3`, uses `enp0s20u3c2` as WAN, enables IPv4/IPv6 forwarding, and NATs LAN traffic. Other hosts are documented in [[Alexandria]], [[Babylon]], and [[Rome]].

## Change checklist

- [ ] Confirm the module is imported in `hosts/istanbul/modules/default.nix`.
- [ ] Run `nixos-rebuild dry-build --flake .#istanbul`.
- [ ] Validate ingress, DNS, and VPN invariants after deployment.