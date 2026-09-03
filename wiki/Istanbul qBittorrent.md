#service/qbittorrent #host/istanbul #status/active #area/music

> [!abstract] Purpose
> qBittorrent downloads music for Lidarr while binding torrent traffic to the isolated WireGuard interface.

## Configuration

- Web UI listens on `:8181`.
- Runs with the `music` group.
- Downloads to `/tmp/music`.
- `Interface = wg0` and `InterfaceAddress = 10.2.0.2`.
- Receives the `media-vpn` namespace path through systemd.

## Dependencies

Requires [[Istanbul Music Namespace]], [[Istanbul WireGuard]], and [[Istanbul Lidarr]]. The Lidarr category must continue pointing at `/tmp/music`.

> [!warning] Fail-closed expectation
> If `media-vpn` or `wg0` is unavailable, torrent traffic should not silently use the host's ordinary route.

[^source]: `hosts/istanbul/modules/music/qbittorrent.nix`, `hosts/istanbul/modules/music/vpn.nix`
