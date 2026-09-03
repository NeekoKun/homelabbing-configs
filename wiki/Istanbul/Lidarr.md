#service/lidarr #host/istanbul #status/active #area/music

> [!abstract] Purpose
> Lidarr automates music acquisition and organization for the shared library.

## Configuration

- Listens on `:8686`.
- Runs as `music`.
- Uses the `media-vpn` namespace.
- Is ordered after `netns-media-vpn` and `wireguard-wg0`.

## Data flow

Lidarr coordinates with Prowlarr and qBittorrent, then organizes completed downloads from `/tmp/music` into `/data/music`.

[^source]: `hosts/istanbul/modules/music/lidarr.nix`, `hosts/istanbul/modules/music/default.nix`
