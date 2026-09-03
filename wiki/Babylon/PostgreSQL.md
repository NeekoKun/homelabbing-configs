#service/postgresql #host/babylon #status/active #area/database

> [!abstract] Purpose
> PostgreSQL is the persistent database backend for Matrix Synapse.

## Configuration

- PostgreSQL is enabled on Babylon.
- Initializes the `matrix-synapse` role and database.
- Uses the `C` locale for the Matrix database.
- The database is intended for local Synapse access.

## Dependencies

[[Synapse]] must start after database initialization. Backups and disk capacity are operational responsibilities not expressed by the current module.

[^source]: `hosts/babylon/modules/postgresql.nix`, `hosts/babylon/modules/synapse.nix`
