# Istanbul - Edge Services

## CoreDNS

CoreDNS listens on port `53` and provides:

- `home.arpa.` mapping `server.home.arpa` to `192.168.1.60`;
- `station.` mapping `vodafone.station` to `192.168.1.1`;
- an ad-blocking hosts file at `/var/lib/coredns/ad-blocklist.hosts`;
- fallback forwarding to Cloudflare DNS over TLS (`1.1.1.1`, SNI `cloudflare-dns.com`);
- caching.

A oneshot service downloads StevenBlack's hosts list every 30 minutes, validates that it is non-trivial, and only then replaces the current `0.0.0.0` entries. CoreDNS reloads the file every five minutes.

> [!tip] Failure behavior
> A failed or suspicious download leaves the previous blocklist in place. The service uses a temporary file before replacement.

## Nginx and ACME

Nginx listens locally on TLS port `8443`; an Nginx stream listener accepts public `443` and uses SNI to route either SSH-over-TLS traffic for `contacts.neekokun.com` or HTTPS traffic to the local TLS backend. HTTP port `80` redirects the wiki and contacts hostnames to HTTPS.

Configured virtual hosts include:

| Hostname | Upstream or behavior |
| --- | --- |
| `wiki.neekokun.com` | Static root from `inputs.myWiki.packages.x86_64-linux.wiki` |
| `navidrome.neekokun.com` | Local port `4533` |
| `vaultwarden.neekokun.com` | Alexandria port `8222` |
| `nextcloud.neekokun.com` | Alexandria default HTTP service |
| `grafana.neekokun.com` | Rome port `2342` |
| `matrix.neekokun.com` | Babylon port `8008`, websockets enabled |
| `contacts.neekokun.com` | SSH/TLS entry and contacts redirect behavior |
| `neekokun.com` | Matrix well-known endpoints and default site |

Every public HTTPS vhost uses ACME and force-SSL settings. Nginx emits JSON access logs to `/var/log/nginx/access.log` and enables recommended TLS, proxy, gzip, and optimization settings.

## SSH and SSH-over-TLS

OpenSSH binds to `127.0.0.1:22`, disables password authentication, and prohibits root password login. `fail2ban` enables an SSH jail on port `4343` with five retries and a one-hour ban; its ban duration can increase up to seven days.

The local transport is:

```text
public :443 + SNI contacts.neekokun.com
  -> nginx stream :8022
  -> stunnel :8022 -> sslh :2222
  -> SSH :22 or TLS :8222
```

`stunnel` uses the ACME certificate for `contacts.neekokun.com`. `sslh` multiplexes SSH and TLS on `127.0.0.1:2222`; the TLS branch reaches the local Nginx fallback on port `8222`.

## Dynamic DNS and GeoIP

The `ddns` system user runs a Cloudflare update script every five minutes. It reads the encrypted environment file, discovers the public address from `ifconfig.me`, and updates the `neekokun.com` A record with a 120-second TTL and proxying disabled.

GeoIP Update retrieves the `GeoLite2-City` database into `/var/lib/geoip` using an age-managed MaxMind license key.

[^source]: These details are derived from `hosts/istanbul/modules/dns.nix`, `nginx.nix`, `openssh.nix`, `SSHoTLS.nix`, `ddns.nix`, and `geoip.nix`.

> [!cite] Source note
> The service relationships above are a condensed reading of the active module definitions, not an independent network scan.[^source]