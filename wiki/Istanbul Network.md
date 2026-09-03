#service/networking #host/istanbul #status/active #area/network

> [!abstract] Purpose
> Istanbul routes the LAN to the WAN and provides the firewall boundary for the homelab.

## Configuration

- LAN interface `enp0s3`: `192.168.2.1/24`.
- WAN interface `enp0s20u3c2`.
- IPv4 and IPv6 forwarding are enabled.
- NAT masquerades traffic from WAN to LAN.
- Static records point to Rome `.2`, Babylon `.3`, and Alexandria `.4`.

## Firewall surface

- LAN DNS TCP/UDP `53`.
- Public TCP `80`, `443`, and `8080`.
- UDP `49152-65535` for the intended Coturn relay range.
- LAN interface is trusted.

> [!warning] Configuration mismatch
> The Coturn UDP range remains open while [[Istanbul Coturn]] is disabled. Reconcile this before tightening or auditing the firewall.

[^source]: `hosts/istanbul/networking.nix`, `flake.nix`
