# Operations and Secrets

## Encrypted secret model

Secrets use [age](https://github.com/FiloSottile/age) and agenix. `secrets/secrets.nix` maps encrypted files to the admin key and the host keys that need to decrypt them.

| Secret file | Recipients / current use |
| --- | --- |
| `admin-password.age` | All hosts and admin |
| `cloudflare-env.age` | Admin and Istanbul DDNS |
| `proton-private-key.age` | Admin and Istanbul WireGuard |
| `maxmind-license-key.age` | Admin and Istanbul GeoIP |
| `coturn-secret.age` | Admin, Istanbul, and Babylon |
| `nextcloud-admin-password.age` | Admin and Alexandria |
| `vaultwarden-env.age` | Admin and Alexandria |

> [!danger] Handling rule
> Only filenames, owners, and purpose belong in the wiki. Keep decrypted values outside version control and avoid displaying them in command output.

## Safe change loop

1. Edit the smallest relevant Nix module.
2. Run `nix flake check` when the change crosses the flake boundary.
3. Run `nixos-rebuild dry-build --flake .#istanbul` for Istanbul changes.
4. Inspect the generated system or service logs.
5. Switch locally or deploy remotely only after the dry build succeeds.

```bash
# Inspect the available outputs
nix flake show

# Check the flake
nix flake check

# Build the current Istanbul system without activating it
nixos-rebuild dry-build --flake .#istanbul

# Follow a service after deployment
journalctl -u nginx -f
journalctl -u cloudflare-ddns -n 50
```

## Useful invariants

- [ ] No public service should bypass the Nginx/ACME ingress policy unintentionally.
- [ ] DNS port `53` should remain reachable from the LAN.
- [ ] WireGuard-bound music services should remain inside `media-vpn`.
- [ ] The `MUSIC` mount should be present before Navidrome starts.
- [ ] Disabled services should not be described as active in deployment notes.
- [ ] Password assignments in shared configuration should be reviewed before production use.

## Known review points

- `hosts/istanbul/networking.nix` opens the broad Coturn UDP range although `coturn.nix` is disabled.
- `hosts/istanbul/modules/nginx.nix` and `SSHoTLS.nix` share local port `8222` across separate listener contexts; verify the intended fallback path with the generated Nginx and systemd configuration.
- The wiki vhost serves the external `myWiki` package, so changes in this local `wiki/` directory require the wiki input/package workflow to become visible at the public hostname.