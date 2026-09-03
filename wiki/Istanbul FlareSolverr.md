#service/flaresolverr #host/istanbul #status/active #area/music

> [!abstract] Purpose
> FlareSolverr assists indexer access when challenge pages require browser-like solving.

## Configuration

- Listens on `:8191`.
- Runs inside `media-vpn` with namespace DNS.
- Starts after `netns-media-vpn` and `wireguard-wg0`.

## Dependencies

Prowlarr may use FlareSolverr for compatible indexers. Its availability and external challenge behavior should be checked after VPN or namespace changes.

[^source]: `hosts/istanbul/modules/music/flaresolverr.nix`, `hosts/istanbul/modules/music/netns.nix`
