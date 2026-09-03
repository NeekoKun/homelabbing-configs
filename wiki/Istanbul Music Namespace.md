#service/network-namespace #host/istanbul #status/active #area/music

> [!abstract] Purpose
> `media-vpn` isolates the automation stack and provides a dedicated route for its WireGuard tunnel.

## Configuration

- Host veth `media-vpn-host`: `10.200.0.1/30`.
- Namespace veth `media-vpn`: `10.200.0.2/30`.
- Namespace DNS is supplied through `/etc/netns/media-vpn/resolv.conf`.
- WireGuard `wg0` is created inside the namespace.

## Dependencies

The namespace must exist before `wireguard-wg0.service`; Lidarr, Prowlarr, FlareSolverr, and qBittorrent are ordered after the namespace and VPN.

> [!warning] Routing invariant
> VPN-bound services should fail closed if the namespace or WireGuard unit is unavailable. Confirm this after network changes.

[^source]: `hosts/istanbul/modules/music/netns.nix`, `hosts/istanbul/modules/music/default.nix`
