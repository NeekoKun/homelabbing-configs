#service/nginx #host/istanbul #status/active #area/ingress

> [!abstract] Purpose
> Nginx is the public TLS ingress, reverse proxy, static wiki server, and SNI dispatcher for Istanbul.

## Configuration

- Public HTTP `:80` redirects configured sites to HTTPS.
- Public TLS `:443` is an Nginx stream listener that dispatches by SNI.
- Local HTTPS backend listens on `127.0.0.1:8443`.
- ACME certificates and force-SSL are enabled for public virtual hosts.
- JSON access logs are written to `/var/log/nginx/access.log`.

## Routes

| Hostname | Destination |
| --- | --- |
| `wiki.neekokun.com` | External `myWiki` package |
| `navidrome.neekokun.com` | `127.0.0.1:4533` |
| `vaultwarden.neekokun.com` | Alexandria `192.168.2.4:8222` |
| `nextcloud.neekokun.com` | Alexandria HTTP `:80` |
| `grafana.neekokun.com` | Rome `192.168.2.2:2342` |
| `matrix.neekokun.com` | Babylon `192.168.2.3:8008` |
| `neekokun.com` | Matrix well-known responses and default site |
| `contacts.neekokun.com` | SSH-over-TLS entry point and redirect behavior |

## Dependencies

Nginx depends on ACME certificate issuance and the upstream service being reachable on the LAN. Its `contacts` stream path cooperates with [[Istanbul SSH-over-TLS]].

> [!note] Documentation packaging
> The wiki vhost serves the external `myWiki` flake input. Local `wiki/` edits are not automatically the public package until that input is updated.

## Operations

```bash
nginx -t
journalctl -u nginx -n 50
```

[^source]: `hosts/istanbul/modules/nginx.nix`, `hosts/istanbul/networking.nix`
