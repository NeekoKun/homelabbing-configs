#service/wireguard #host/istanbul #status/active #area/music

> [!abstract] Purpose
> WireGuard provides the music stack's isolated egress path.

## Configuration

- Interface: `wg0` inside namespace `media-vpn`.
- IPv4: `10.2.0.2/32`.
- IPv6: `2a07:b944::2:2/128`.
- Full IPv4 and IPv6 routes are installed through the peer.
- Peer endpoint: `146.70.202.50:51820`; keepalive: 25 seconds.
- Private key comes from `proton-private-key.age`.

## Consumers

qBittorrent binds torrent traffic to `wg0`; the other automation services are placed in the same namespace and ordered behind the VPN.

## Operations

```bash
ip netns exec media-vpn wg show
journalctl -u wireguard-wg0 -n 50
```

[^source]: `hosts/istanbul/modules/music/vpn.nix`, `secrets/secrets.nix`
