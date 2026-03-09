# Homelabbing Configs

A comprehensive NixOS configuration for a multi-host homelab setup with services for media streaming, messaging, identity management, monitoring, and VOIP infrastructure.

## Overview

This repository contains declarative NixOS configurations for four primary hosts managing various services across a private network. Each host is purpose-built with minimal redundancy and focused service provisioning.

## Infrastructure Architecture

### Host Topology

```
alexandria    - Media & Cloud Services
├── Navidrome      (Music streaming)
├── Nextcloud      (File sync & collaboration)
└── Vaultwarden    (Password management)

babylon       - Messaging Platform
├── Synapse        (Matrix homeserver)
├── Synapse Admin  (Administration interface)
└── PostgreSQL     (Database)

istanbul      - Network Edge
├── Coturn         (TURN server for P2P)
├── DDNS           (Dynamic DNS)
├── Nginx          (Reverse proxy)
└── Suricata       (IDS/IPS)

rome          - Observability Stack
├── Prometheus     (Metrics collection)
├── Loki           (Log aggregation)
├── Grafana        (Visualization & dashboarding)
└── Dashboards     (Host-specific monitoring)
```

## Directory Structure

```
.
├── hosts/                          # Host-specific configurations
│   ├── alexandria/                 # Media and cloud services host
│   │   ├── default.nix            # Main configuration
│   │   ├── networking.nix         # Network setup
│   │   └── modules/               # Service modules
│   ├── babylon/                    # Matrix homeserver host
│   │   ├── default.nix
│   │   ├── networking.nix
│   │   └── modules/
│   ├── istanbul/                   # Network edge host
│   │   ├── default.nix
│   │   ├── networking.nix
│   │   └── modules/
│   └── rome/                       # Monitoring host
│       ├── default.nix
│       ├── networking.nix
│       ├── modules/
│       └── modules/dashboards/     # Grafana dashboards
├── nixos/                          # Shared NixOS configurations
│   ├── default.nix
│   ├── bash.nix                    # Bash shell configuration
│   └── kmscon.nix                  # Console configuration
├── secrets/                        # Age-encrypted secrets
│   ├── secrets.nix                 # Secret declarations
│   └── *.age                       # Encrypted files
├── configuration.nix               # Top-level configuration
├── flake.nix                       # Flakes configuration
├── colors.py                       # Utility script for color handling
└── README.md                       # This file
```

## Services Overview

### Alexandria (Media & Cloud)

- **Navidrome**: Self-hosted music streaming server
- **Nextcloud**: Complete collaboration platform with file sync, calendar, contacts, and office apps
- **Vaultwarden**: Lightweight Bitwarden-compatible password manager

### Babylon (Messaging)

- **Synapse**: Matrix protocol homeserver for decentralized messaging
- **Synapse Admin**: Web interface for server administration
- **PostgreSQL**: Database backend for Synapse

### Istanbul (Network Edge)

- **Coturn**: TURN/STUN server for NAT traversal and P2P connections
- **DDNS**: Dynamic DNS client for dynamic IP management
- **Nginx**: Reverse proxy and load balancer
- **Suricata**: Network IDS/IPS for intrusion detection and prevention

### Rome (Observability)

- **Prometheus**: Metrics collection and time-series database
- **Loki**: Log aggregation system
- **Grafana**: Metrics visualization and dashboard platform
- **Host Dashboards**: Preconfigured dashboards for Alexandria, Babylon, Istanbul, Rome, Nginx, Fail2ban, and general host metrics

## Roadmap
See [ROADMAp.md](/ROADMAP.md) for informations on planned features

## Prerequisites

- NixOS installed on target machines
- SSH access to target machines
- Age encryption setup for secrets management
- Flakes enabled in your NixOS configuration

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/NeekoKun/homelabbing-configs.git
cd homelabbing-configs
```

### 2. Configure Secrets

Secrets are managed using [age](https://github.com/FiloSottile/age) and integrated with NixOS via [agenix](https://github.com/ryantm/agenix).

The keys should be automatically generated with the OpenSSH service, and can be found under /etc/ssh/ssh_host_ed25519_key.pub. The user keys can be found at ~/.ssh/id_ed25519_key.pub

To add or modify secrets:

```bash
agenix -e secrets/secret-name.age
```

#### Needed Secrets:

Every secret can be inferred by the [secrets.nix](secrets/secrets.nix) file, but here is a comprehensive list with uses:

- Password for admin account
- Cloudflare API key and ZONE_ID, with zone:DNS:Edit and zone:DNS:Read permissions, formatted as follows:

```bash
CLOUDFLARE_API_KEY=<your_cloudflare_api_key>
CLOUDFLARE_ZONE_ID=<your_cloudflare_zone_id>
```

- Coturn local secret, can be whatever
- MaxMind license key for GeoIP tracking of banned IPs
- Vaultwarden ADMIN token, needed to login as admin, formatted as follows:

```bash
ADMIN_TOKEN=<token_of_your_choice>
```

- NextCloud admin password.

### 3. Deploy to a Host

Deploy using NixOS's nixos-rebuild:

```bash
# For remote deployment
nixos-rebuild switch --flake .#hostname --target-host user@hostname

# For local deployment
nixos-rebuild switch --flake .#hostname
```

### 4. Access Services

After deployment, services are accessible via:

- **Navidrome**: https://navidrome.domain.tld
- **Nextcloud**: https://nextcloud.domain.tld
- **Vaultwarden**: https://vaultwarden.domain.tld
- **Synapse**: https://matrix.domain.tld (Matrix homeserver)
- **Synapse Admin**: https://localhost:8080 from **Babylon**, through port forwarding
- **Grafana**: https://grafana.domain.tld

## Configuration Management

### Secrets

All sensitive data is stored in [secrets/](secrets/) using age encryption:

- `admin-password.age` - Administrative credentials
- `cloudflare-env.age` - Cloudflare API configuration
- `coturn-secret.age` - TURN server secret
- `maxmind-license-key.age` - MaxMind GeoIP license
- `nextcloud-admin-password.age` - Nextcloud admin credentials
- `vaultwarden-env.age` - Vaultwarden environment variables

Secrets are declared in [secrets/secrets.nix](secrets/secrets.nix) and referenced by their respective service modules.

### Common Modules

Shared configurations across hosts:

- **bash.nix**: Bash shell settings and aliases
- **kmscon.nix**: Linux kernel mode setting console
- **Vector**: Unified logging pipeline for all hosts

## Networking

Each host has a dedicated `networking.nix` for:

- Static IP configuration
- Firewall rules
- DNS settings
- Network interface setup

## Monitoring & Logging

All hosts forward logs to the Rome monitoring stack:

- **Prometheus**: Scrapes metrics from host exporters
- **Loki**: Aggregates logs from Vector agents
- **Grafana**: Visualizes both metrics and logs with dashboard templates for each host

## Development

### Making Changes

1. Edit the relevant configuration files
2. Test locally with `nixos-rebuild dry-build`
3. Deploy with `nixos-rebuild switch --flake`

### Adding a New Service

1. Create a new module in the appropriate host's `modules/` directory
2. Add module configuration following existing patterns
3. Reference it in the host's `modules/default.nix`
4. Commit and deploy

## Troubleshooting

### Service Won't Start

Check logs with `journalctl`

```bash
journalctl -u service-name -n 50   # Last 50 lines
journalctl -u service-name -f      # Follow logs
```

### Secrets Issues

Verify secrets are correctly being decrypted by agenix

```bash
sudo ls -la /run/agenix/
sudo cat /run/agenix/<your_secret>
```

- If the secrets appear correctly decrypted, the issue is in the provisioning configs
- If the secrets are gibberish, the keys are wrong and have to be replaced, follow the [configuration](###2. Configure Secrets)

### Networking Issues

Check host connectivity and firewall rules:

```bash
ip addr show
sudo nft list ruleset  # For nftables
```

## Maintenance

### Regular Updates

Update the flake periodically:

```bash
nix flake update
```

### Backup Strategy

Ensure critical data on Alexandria and Babylon is backed up regularly:

- Nextcloud files
- Vaultwarden database
- Synapse database

## License

This project is licensed under the GNU General Public License v3.0 (GPLv3). See [LICENSE](LICENSE) file for details.

These configurations are provided as-is for personal homelab use. Any modifications or distributions must comply with GPLv3 terms, including making source code available under the same license.

## References

- [NixOS Documentation](https://nixos.org/manual/nixos/stable/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [Agenix - Age integration for NixOS](https://github.com/ryantm/agenix)
- [Service Documentation](https://nixos.org/manual/nixpkgs/stable/)

## Notes

- All services are configured with TLS/SSL enabled
- Vector is used as the primary logging pipeline
- Services are optimized for minimal resource usage
- Monitor and log retention can be configured in Rome's modules