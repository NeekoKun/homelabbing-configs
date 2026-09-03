#service/prowlarr #host/istanbul #status/active #area/music

> [!abstract] Purpose
> Prowlarr provides indexer management for the music automation stack.

## Configuration

- Listens on `:9696`.
- Runs inside `media-vpn`.
- Uses the namespace DNS configuration.
- Starts after the namespace and WireGuard service.

## Dependencies

Prowlarr supplies indexer results to [[Lidarr]] and must retain access to the VPN namespace for its network requests.

[^source]: `hosts/istanbul/modules/music/prowlarr.nix`, `hosts/istanbul/modules/music/netns.nix`
