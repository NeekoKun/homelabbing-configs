#service/openssh #host/istanbul #status/active #area/access

> [!abstract] Purpose
> OpenSSH provides administrative access, but is bound locally so the public entry path can be multiplexed by SSH-over-TLS.

## Configuration

- Listens on `127.0.0.1:22`.
- Password authentication is disabled.
- Root password login is prohibited.
- Fail2ban protects the SSH jail on port `4343`, with five retries and a one-hour initial ban; the ban can grow to seven days.

## Dependencies

The public access path depends on [[Istanbul SSH-over-TLS]]. LAN administration depends on firewall reachability and the configured admin key.

## Operations

```bash
journalctl -u sshd -n 50
journalctl -u fail2ban -n 50
fail2ban-client status sshd
```

[^source]: `hosts/istanbul/modules/openssh.nix`, `hosts/istanbul/modules/SSHoTLS.nix`
