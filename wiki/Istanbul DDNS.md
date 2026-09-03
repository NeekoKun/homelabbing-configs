#service/ddns #host/istanbul #status/active #area/dns

> [!abstract] Purpose
> The DDNS job keeps the Cloudflare `neekokun.com` A record aligned with Istanbul's current public IPv4 address.

## Configuration

- Runs as the `ddns` system user every five minutes.
- Discovers the address from `ifconfig.me`.
- Uses a 120-second DNS TTL and disables Cloudflare proxying.
- Reads the encrypted `cloudflare-env.age` environment through agenix.

## Dependencies

Requires outbound connectivity, Cloudflare credentials, and a working public address discovery endpoint.

## Operations

```bash
journalctl -u cloudflare-ddns -n 50
systemctl status cloudflare-ddns.timer
```

[^source]: `hosts/istanbul/modules/ddns.nix`, `secrets/secrets.nix`
