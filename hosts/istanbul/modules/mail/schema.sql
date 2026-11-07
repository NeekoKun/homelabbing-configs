CREATE TABLE IF NOT EXISTS domains (
    name text PRIMARY KEY CHECK (name ~ '^[a-z0-9][a-z0-9.-]*$')
);

CREATE TABLE IF NOT EXISTS users (
    id            bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    localpart     text    NOT NULL CHECK (localpart ~ '^[a-z0-9][a-z0-9._+-]*$'),
    domain        text    NOT NULL REFERENCES domains(name),
    password_hash text    NOT NULL,
    enabled       boolean NOT NULL DEFAULT true,
    UNIQUE (localpart, domain)
);

CREATE TABLE IF NOT EXISTS aliases (
    id          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source      text    NOT NULL CHECK (source = lower(source)),
    destination text    NOT NULL CHECK (destination = lower(destination)),
    enabled     boolean NOT NULL DEFAULT true,
    UNIQUE (source, destination)
);

GRANT SELECT ON users                   TO dovecot2;
GRANT SELECT ON domains, users, aliases TO postfix;