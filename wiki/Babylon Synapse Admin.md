#service/synapse-admin #host/babylon #status/active #area/messaging

> [!abstract] Purpose
> Synapse Admin is a static administration frontend served locally on Babylon.

## Configuration

- Served by `darkhttpd`.
- Listens on `127.0.0.1:8080`.
- It is not directly exposed as a public service by the current Nginx route table.

## Dependencies

Requires the static frontend files and a reachable Synapse API for useful administration. Confirm the intended access path before exposing it beyond localhost.

[^source]: `hosts/babylon/modules/synapse-admin.nix`, `hosts/babylon/networking.nix`
