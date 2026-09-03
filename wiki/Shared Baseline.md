#area/platform #status/active

> [!abstract] Purpose
> Shared configuration defines the common NixOS baseline applied to every host.

## Configuration

- Flake inputs and all four `x86_64-linux` host outputs are defined in `flake.nix`.
- `configuration.nix` provides boot, users, packages, Bash/tmux behavior, daily garbage collection, and weekly cleanup of generations older than five.
- Systemd-boot is used.
- Timezone is `Europe/Rome`.
- System state version is `25.11`.
- Agenix is imported for encrypted secrets.

## Host activation

Each host imports its `networking.nix` and `modules/default.nix`; the latter is the service activation boundary. A module file is not active merely because it exists.

## Operations

```bash
nix flake check
nix flake show
nixos-rebuild dry-build --flake .#<host>
```

[^source]: `flake.nix`, `configuration.nix`, `nixos/default.nix`, `nixos/bash.nix`
