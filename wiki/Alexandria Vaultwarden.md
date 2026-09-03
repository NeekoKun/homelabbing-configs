#service/vaultwarden #host/alexandria #status/active #area/security

> [!abstract] Purpose
> Vaultwarden provides the password-manager service for the homelab.

## Configuration

- Listens on `0.0.0.0:8222`.
- Public domain: `vaultwarden.neekokun.com`.
- User signups are disabled.
- Backup directory: `/home/vaultwarden/data`.
- Runtime environment comes from `vaultwarden-env.age`.

## Access

Istanbul Nginx proxies the public hostname to `192.168.2.4:8222`. Keep the service's domain and proxy behavior aligned when changing either host.

[^source]: `hosts/alexandria/modules/vaultwarden.nix`, `hosts/istanbul/modules/nginx.nix`, `secrets/secrets.nix`
