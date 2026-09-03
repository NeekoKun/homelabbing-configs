#service/navidrome #host/alexandria #status/active #area/media

> [!abstract] Purpose
> Alexandria's Navidrome is a second media server instance using the Alexandria music disk.

## Configuration

- Listens on `0.0.0.0:4533`.
- Reads `/mnt/music`.
- `/dev/sdb` mounts at `/mnt/music`.
- Starts after `mnt-music.mount`.

## Access

The public Navidrome route currently targets Istanbul's local instance. Treat this Alexandria instance as a separately configured service until the proxy target is intentionally changed.

[^source]: `hosts/alexandria/modules/navidrome.nix`, `hosts/istanbul/modules/nginx.nix`
