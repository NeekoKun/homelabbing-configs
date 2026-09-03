# Homelabbing Configs

> [!summary] Scope
> This is the working wiki for the homelab NixOS repository. It starts from the repository README and currently documents the shared configuration plus **Istanbul**, the network-edge host. The other hosts are intentionally out of scope for this first pass.

## Start here

- [[README - Project Overview|Project overview]] - the repository's purpose, topology, prerequisites, and deployment flow.
- [[Shared Configuration|Shared configuration]] - flake inputs, host construction, common variables, and base NixOS settings.
- [[Istanbul - Network Edge|Istanbul]] - the host boundary, addressing, NAT, firewall, and module inventory.
- [[Istanbul - Edge Services|Edge services]] - DNS, reverse proxying, ACME, DDNS, GeoIP, SSH, and SSH-over-TLS.
- [[Istanbul - Music Stack|Music stack]] - the isolated VPN namespace and music automation services.
- [[Operations and Secrets|Operations and secrets]] - deployment, checks, encrypted secret ownership, and operational notes.

## Repository map

```text
wiki/
├── index.md
├── README - Project Overview.md
├── Shared Configuration.md
├── Istanbul - Network Edge.md
├── Istanbul - Edge Services.md
├── Istanbul - Music Stack.md
└── Operations and Secrets.md
```

## Current coverage

- [x] README-derived project overview
- [x] Host-agnostic flake and base configuration
- [x] `secrets/secrets.nix` ownership map
- [x] Istanbul active modules
- [x] Istanbul inactive modules called out explicitly
- [ ] Alexandria, Babylon, and Rome service pages

## Reading conventions

Obsidian wikilinks connect the notes. Source paths are shown as `inline code`; values that are credentials, tokens, or private keys are deliberately not reproduced here. Notes use **bold**, *italic*, and ~~strikethrough~~ where useful.

[^scope]: The source files are the authority. This wiki describes their current declarative intent and notes obvious operational dependencies; it does not replace `nixos-rebuild` validation.

## Sources

1. Repository `README.md`, `flake.nix`, `configuration.nix`, `nixos/`, `secrets/secrets.nix`, and `hosts/istanbul/`.
2. [[Operations and Secrets|Operational notes]] for the validation and deployment commands.

> [!question] Why only Istanbul?
> The README describes four hosts, but this initial wiki pass follows the requested boundary: shared configuration first, then Istanbul only.[^scope]