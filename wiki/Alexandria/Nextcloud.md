#service/nextcloud #host/alexandria #status/active #area/cloud

> [!abstract] Purpose
> Nextcloud provides the cloud platform for Alexandria, including News, Contacts, Calendar, and Tasks.

## Configuration

- Public hostname: `nextcloud.neekokun.com`.
- Serves HTTP on Alexandria's default port `80` behind Istanbul.
- Uses PostgreSQL through its local socket backend.
- Trusts Istanbul as the reverse proxy and trusts Alexandria/Istanbul addresses.
- Bootstrap admin password comes from `nextcloud-admin-password.age`.

## Dependencies

Requires the Nextcloud PostgreSQL database and the agenix secret. Public TLS and hostname handling belong to [[Nginx]].

## Operations

```bash
journalctl -u nextcloud-setup -n 50
journalctl -u phpfpm-nextcloud -n 50
```

[^source]: `hosts/alexandria/modules/nextcloud.nix`, `secrets/secrets.nix`
