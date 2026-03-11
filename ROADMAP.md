# Homelabbing Configs Roadmap

Progress tracking and planned enhancements for the homelabbing infrastructure.

## Milestones

### 0. Go Public

**Status:** Current Focus

Turn the github repo public

- [ ] Cleanup history for old plaintext keys
- [x] Rotate every key
- [ ] Change admin password to an actual password instead of 1234
- [x] Go public

### 1. Extending Grafana Dashboard

**Status:** In Progress

Enhance monitoring and visualization capabilities across all hosts.

#### Tasks
- [ ] Create host-specific performance dashboards
  - [ ] CPU, Memory, Disk I/O utilization graphs
    - [ ] Benchmark ~~Babylon and~~ Alexandria with ```fio```
  - [x] Network throughput and latency metrics
  - [ ] Temperature monitoring (if applicable)
- [ ] Service-level dashboards
  - [ ] Navidrome: playback statistics and user activity
  - [ ] Nextcloud: storage usage and user metrics
  - [ ] Synapse: room activity and federation metrics
  - [x] Nginx: request rates, error codes, response times
- [ ] SLA and uptime tracking
  - [ ] Service availability graphs
  - [ ] Downtime incident tracking
  - [ ] Historical availability reports
- [ ] Log-based visualizations
  - [ ] Error frequency heatmaps
  - [x] Request path analysis
  - [x] Failed login attempts tracking
- [ ] Alert threshold configuration
  - [x] High disk usage alerts
  - [ ] Service downtime detection
  - [ ] Anomaly detection setup
- [ ] Add dashboard showcase to [README.md](/README.md)
  - [ ] Add main gauges showcase
  - [ ] Add GeoIP tracking showcase
  - [ ] Add custom .md file to showcase every dashboard

#### Related Files
- `hosts/rome/modules/grafana.nix`
- `hosts/rome/modules/dashboards/`

#### Dependencies
- Prometheus metrics exposed by all services
- Loki logs properly ingested via Vector

---

### 2. Extending Matrix to Support Element Calls

**Status:** Planned

Implement VoIP/video calling capabilities for the Matrix homeserver using Element Call and Coturn.

#### Tasks
- [ ] Configure Element Call integration
  - [ ] Element Call container setup (babylon)
  - [ ] TURN server configuration (already partially done on Istanbul)
  - [x] Coturn secret management via agenix
- [ ] SFU setup (Selective Forwarding Unit)
  - [ ] Consider Livekit or similar SFU deployment
  - [ ] Media bridge configuration
- [ ] Testing
  - [ ] Test peer-to-peer calls
  - [ ] Test group calls with SFU
  - [ ] Test calls through NAT
- [ ] Documentation
  - [ ] Element Call setup guide
  - [ ] Troubleshooting common VoIP issues
  - [ ] Client configuration guide

#### Related Files
- `hosts/babylon/modules/synapse.nix` (add Element Call config)
- `hosts/istanbul/modules/coturn.nix` (extend configuration)
- `secrets/coturn-secret.age`

#### Dependencies
- Working Matrix homeserver (Synapse)
- Functional Coturn TURN server
- Public domain/DNS with proper SRV records

---

### 3. Setting Up Nextcloud

**Status:** Partially Complete

Complete Nextcloud deployment and configuration for file synchronization and collaboration.

#### Tasks
- [ ] Core Nextcloud setup
  - [x] NixOS module configuration
  - [ ] Initial admin account creation
  - [x] HTTPS certificate setup
  - [ ] Database optimization (PostgreSQL on babylon)
- [ ] Essential apps installation
  - [x] Contacts app
  - [x] Calendar app
  - [x] Tasks app
  - [ ] Deck (kanban boards)
- [ ] User and permission management
  - [ ] User account provisioning
  - [ ] Group creation
  - [ ] Share permissions configuration
  - [ ] LDAP integration (optional)
- [ ] Backup and recovery
  - [ ] Backup script setup
  - [ ] Automated backup scheduling
  - [ ] Recovery procedure documentation
- [ ] Client setup
  - [ ] Desktop sync client configuration
  - [ ] Mobile app setup
  - [ ] Browser access verification
- [ ] Performance tuning
  - [ ] PHP-FPM optimization
  - [ ] Memory caching setup (Redis/Memcached)
  - [ ] Background job scheduling
- [ ] Security hardening
  - [ ] Enable two-factor authentication
  - [ ] Configure brute force protection
  - [ ] Set resource limits

#### Related Files
- `hosts/alexandria/modules/nextcloud.nix`
- `secrets/nextcloud-admin-password.age`

#### Dependencies
- Database backend (PostgreSQL or MySQL)
- Reverse proxy (Nginx on istanbul)
- Persistent storage
- HTTPS certificates

---

### 4. Setting Up Vaultwarden

**Status:** Partially Complete

Deploy and configure Vaultwarden for secure password and secret management.

#### Tasks
- [ ] Core Vaultwarden setup
  - [x] NixOS module configuration
  - [x] Admin panel access setup
  - [ ] Initial organization creation
  - [ ] Database setup (SQLite or PostgreSQL)
- [ ] User and organization management
  - [ ] User account creation
  - [ ] Organization/collection structure
  - [ ] Access control configuration
  - [ ] Invite system setup
- [ ] Client installation
  - [ ] Browser extension setup (Chrome, Firefox, Safari)
  - [ ] Desktop client configuration
  - [ ] Mobile app setup
  - [ ] CLI tool installation
- [ ] Backup and recovery
  - [ ] Database backup automation
  - [ ] Attachment backup strategy
  - [ ] Disaster recovery testing
- [ ] Security hardening
  - [ ] HTTPS enforcement
  - [ ] Admin panel protection
  - [ ] Two-factor authentication enforcement
  - [ ] Session timeout configuration
- [ ] Integration
  - [ ] Single sign-on (optional)
  - [ ] Password sharing policies
  - [ ] Audit logging

#### Related Files
- `hosts/alexandria/modules/vaultwarden.nix`
- `secrets/vaultwarden-env.age`

#### Dependencies
- Persistent storage
- Database backend
- Reverse proxy (Nginx)
- HTTPS certificates

---

### 5. Deploying to Bare Metal

**Status:** Planned

Transition from virtual machines to bare metal deployments for improved performance.

#### Phase 1: Planning & Preparation
- [ ] Hardware selection and procurement
  - [ ] Define performance requirements per host
  - [ ] Select appropriate hardware
  - [ ] Plan network topology
- [ ] Network planning
  - [ ] IP address scheme
  - [ ] VLAN configuration (if needed)
  - [ ] Firewall rules preparation
- [ ] Storage planning
  - [ ] Disk layout and partitioning
  - [ ] RAID configuration (if applicable)
  - [ ] Backup storage strategy

#### Phase 2: Infrastructure Setup
- [ ] Install NixOS on bare metal
  - [ ] Create installation media
  - [ ] Configure hardware-specific modules
  - [ ] Test basic networking
- [ ] Network configuration
  - [ ] Configure static IPs
  - [ ] Set up DNS resolution
  - [ ] Verify connectivity
- [ ] Storage setup
  - [ ] Mount persistent volumes
  - [ ] Configure backups
  - [ ] Test recovery procedures

#### Phase 3: Service Migration
- [ ] Alexandria (Media & Cloud)
  - [ ] Deploy Navidrome with music library
  - [ ] Deploy Nextcloud with existing data
  - [ ] Deploy Vaultwarden with existing vaults
- [ ] Babylon (Messaging)
  - [ ] Deploy Synapse with existing rooms/users
  - [ ] Migrate database from virtual environment
  - [ ] Test federation
- [ ] Istanbul (Network Edge)
  - [ ] Deploy Nginx reverse proxy
  - [ ] Deploy Coturn for VOIP
  - [ ] Deploy Suricata IDS
  - [ ] Configure DDNS and GeoIP
- [ ] Rome (Observability)
  - [ ] Deploy Prometheus with scrape configs
  - [ ] Deploy Loki log aggregation
  - [ ] Deploy Grafana dashboards
  - [ ] Test monitoring of new environment

#### Phase 4: Validation & Optimization
- [ ] Performance benchmarking
  - [ ] Compare VM vs bare metal performance
  - [ ] Identify bottlenecks
  - [ ] Optimize resource allocation
- [ ] High availability setup (optional)
  - [ ] Redundant configurations
  - [ ] Failover testing
  - [ ] Load balancing
- [ ] Documentation
  - [ ] Hardware specifications
  - [ ] Installation procedures
  - [ ] Maintenance guides
  - [ ] Troubleshooting guides

#### Phase 5: Production Cutover
- [ ] Final backup of all data
- [ ] Cutover scheduling
- [ ] DNS migration
- [ ] Decommission old VMs
- [ ] Post-deployment validation

#### Related Files
- All files (will need hardware-specific configurations)
- `hardware-configuration.nix` (will be auto-generated per host)
- New configuration files for bare metal

#### Dependencies
- Physical hardware
- Network infrastructure
- Installation media
- Time for comprehensive testing

---

## Cross-Cutting Concerns

### Documentation
- [ ] Deployment guide for new setup
- [x] Architecture documentation
- [ ] Troubleshooting guide
- [ ] Maintenance procedures
- [x] Secret management guide

### Testing
- [ ] Integration test suite
- [ ] Disaster recovery drills
- [ ] Performance test automation
- [ ] Security vulnerability scanning

### Automation
- [ ] CI/CD pipeline setup
- [ ] Configuration validation
- [ ] Automated deployments
- [ ] Backup automation verification

### Security
- [ ] Regular security audits
- [ ] Dependency updates automation
- [ ] Vulnerability scanning
- [ ] Access control review

---

## Priority Levels

### High Priority
1. Bare metal deployment (Phase 1-2)
2. Nextcloud setup completion
3. Vaultwarden setup completion

### Medium Priority
1. Matrix/Element Calls integration
2. Grafana dashboard extensions
3. Security hardening across all services

### Low Priority
1. Advanced monitoring features
2. High availability setup
3. Additional service deployments

---

## Success Criteria

- [ ] All critical services deployable to bare metal
- [ ] Full backup and recovery procedures tested
- [ ] Monitoring and alerting fully operational
- [ ] Documentation complete and tested
- [ ] All systems performing better than current VMs
- [ ] Zero data loss during migration

---

## Notes

- Regularly review and update this roadmap
- Adjust timelines based on available resources and priorities
- Document lessons learned from each milestone
- Keep backups current throughout all phases
