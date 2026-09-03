#service/sshovertls #host/istanbul #status/active #area/access

> [!abstract] Purpose
> The SSH-over-TLS chain shares public port `443` between HTTPS and administrative SSH access using SNI and protocol detection.

## Traffic path

```text
public :443 + SNI contacts.neekokun.com
  -> Nginx stream :8022
  -> stunnel :8022 -> sslh :2222
  -> SSH :22 or TLS :8222
```

## Configuration

- `stunnel` uses the ACME certificate for `contacts.neekokun.com`.
- `sslh` listens on `127.0.0.1:2222` and dispatches SSH to `127.0.0.1:22`.
- TLS/HTTP traffic is sent to Nginx's local fallback on `:8222`.

## Dependencies

Requires the Nginx stream listener, the ACME certificate, `stunnel`, `sslh`, and local OpenSSH. The shared `8222` fallback should be checked against the generated systemd and Nginx configuration after changes.

## Operations

```bash
journalctl -u stunnel -n 50
journalctl -u sslh -n 50
```

[^source]: `hosts/istanbul/modules/SSHoTLS.nix`, `hosts/istanbul/modules/nginx.nix`
