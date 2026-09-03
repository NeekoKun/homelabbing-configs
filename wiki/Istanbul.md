#host/istanbul #role/edge #status/active

> [!abstract] Role
> Istanbul is the LAN gateway, DNS resolver, public ingress point, and isolated egress host for the music automation stack.

## Services

| Service | Status | Note |
| --- | --- | --- |
| [[Istanbul Network]] | Active | Forwarding, NAT, and firewall |
| [[Istanbul CoreDNS]] | Active | LAN DNS and ad blocking |
| [[Istanbul Nginx]] | Active | TLS ingress and reverse proxy |
| [[Istanbul DDNS]] | Active | Cloudflare address updates |
| [[Istanbul GeoIP]] | Active | GeoLite2 database updates |
| [[Istanbul OpenSSH]] | Active | Local SSH endpoint |
| [[Istanbul SSH-over-TLS]] | Active | Public SSH/TLS multiplexer |
| [[Istanbul Music Namespace]] | Active | Isolated media network |
| [[Istanbul WireGuard]] | Active | VPN egress for automation |
| [[Istanbul Navidrome]] | Active | Music playback |
| [[Istanbul Lidarr]] | Active | Music organization |
| [[Istanbul Prowlarr]] | Active | Indexer management |
| [[Istanbul FlareSolverr]] | Active | Challenge solving helper |
| [[Istanbul qBittorrent]] | Active | VPN-bound downloads |
| [[Istanbul Coturn]] | Disabled | Planned TURN relay |
| [[Istanbul Suricata]] | Disabled | Planned WAN IDS |
| [[Istanbul Vector]] | Disabled | Prepared log pipeline |

## Network

Istanbul is `192.168.2.1/24` on `enp0s3`, uses `enp0s20u3c2` as WAN, enables IPv4/IPv6 forwarding, and NATs LAN traffic. Other hosts are documented in [[Alexandria]], [[Babylon]], and [[Rome]].

## Change checklist

- [ ] Confirm the module is imported in `hosts/istanbul/modules/default.nix`.
- [ ] Run `nixos-rebuild dry-build --flake .#istanbul`.
- [ ] Validate ingress, DNS, and VPN invariants after deployment.