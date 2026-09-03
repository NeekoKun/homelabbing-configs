#service/geoip #host/istanbul #status/active #area/security

> [!abstract] Purpose
> GeoIP Update supplies the GeoLite2 City database for services that need geographic address data.

## Configuration

- Stores the database under `/var/lib/geoip`.
- Retrieves `GeoLite2-City` using MaxMind account `1309665`.
- Reads the MaxMind license key from `maxmind-license-key.age`.

## Dependencies

Requires the agenix secret, MaxMind availability, and outbound network access. The database directory must remain readable by consumers without exposing the license key.

## Operations

```bash
journalctl -u geoipupdate -n 50
ls -l /var/lib/geoip
```

[^source]: `hosts/istanbul/modules/geoip.nix`, `secrets/secrets.nix`
