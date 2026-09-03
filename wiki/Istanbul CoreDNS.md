#service/coredns #host/istanbul #status/active #area/dns

> [!abstract] Purpose
> CoreDNS is Istanbul's LAN resolver and local name service.

## Configuration

- Listens on TCP/UDP `53`.
- Serves `home.arpa.` and `station.` zones with local records.
- Serves `/var/lib/coredns/ad-blocklist.hosts` and reloads it every five minutes.
- Forwards misses to Cloudflare DNS over TLS at `1.1.1.1`, with SNI `cloudflare-dns.com`, and caches responses.

## Dependencies

- `coredns` owns the resolver process.
- `coredns-blocklist-update.service` downloads StevenBlack's hosts list every 30 minutes.
- The updater validates a non-trivial temporary file before replacing the active list.

> [!warning] Failure behavior
> A failed or suspicious download leaves the previous blocklist in place.

## Operations

```bash
journalctl -u coredns -n 50
journalctl -u coredns-blocklist-update -n 50
```

[^source]: `hosts/istanbul/modules/dns.nix`, `hosts/istanbul/networking.nix`
