#service/openssh #scope/fleet #status/active #area/access

> [!abstract] Purpose
> OpenSSH is the common administrative access service imported by each host.

## Baseline

The shared host policy uses key-based administration, disables password authentication, and prevents root password login. Host-specific listener and firewall details belong to each host's networking and OpenSSH modules.

## Operations

```bash
journalctl -u sshd -n 50
```

[^source]: `configuration.nix`, `hosts/*/modules/openssh.nix`
