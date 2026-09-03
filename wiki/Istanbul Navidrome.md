#service/navidrome #host/istanbul #status/active #area/music

> [!abstract] Purpose
> Istanbul's Navidrome serves the music library produced by the isolated automation stack.

## Configuration

- Listens on `0.0.0.0:4533`.
- Reads `/data/music`.
- Stores application data under `/var/lib/navidrome`.
- Runs after `data-music.mount`.
- Uses the `music` user and group.

## Storage

The `MUSIC` filesystem is mounted at `/data/music`; the library is `02750` and owned by `music:music`. Downloads land in `/tmp/music` before organization.

## Access

Public access is through `navidrome.neekokun.com` and [[Istanbul Nginx]].

[^source]: `hosts/istanbul/modules/music/navidrome.nix`, `hosts/istanbul/modules/music/default.nix`
