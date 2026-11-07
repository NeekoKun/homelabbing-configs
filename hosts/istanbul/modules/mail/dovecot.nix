# Copyright (C) 2026 NeekoKun
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

{ config, lib, vars, pkgs, ... }:

let 
    certDir = "/var/lib/acme/mail.${vars.network.DNS.domain}.${vars.network.DNS.tld}";
    postfixQueue = "/var/lib/postfix/queue";
in 
{
    users.groups.vmail = {};
    users.users.vmail = {
        isSystemUser = true;
        group = "vmail";
        home = "/var/spool/mail/vmail";
        createHome = true;
    };

    users.users.dovecot2.extraGroups = [ "mailcerts" ];

    services.postgresql = {
        enable = true;
        ensureDatabases = [ "mail" ];
        ensureUsers = [ { name = "dovecot2"; } { name = "postfix"; } ];
    };

    systemd.services.postgresql-setup.postStart = lib.mkAfter ''
        psql -d mail -v ON_ERROR_STOP=1 -f ${./schema.sql}
        psql mail -c "INSERT INTO domains VALUES ('${vars.network.DNS.domain}.${vars.network.DNS.tld}');"
    '';

    services.dovecot2 = {
        enable = true;
        package = pkgs.dovecot.override { withPgSQL = true; };
        enablePAM = false;

        settings = {
            protocols = [ "imap" "lmtp" ];
            dovecot_config_version = "2.4.0";
            dovecot_storage_version = "2.4.0"; # Could change to 2.4.5

            ssl = "required";
            ssl_server_cert_file = "${certDir}/fullchain.pem";
            ssl_server_key_file = "${certDir}/key.pem";
            ssl_min_protocol = "TLSv1.3";

            mail_uid = "vmail";
            mail_gid = "vmail";
            mail_driver = "maildir";
            mail_path = "~/Maildir";

            auth_mechanisms = [ "plain" "login" ];
            auth_username_format = "%{user | lower}";
            sql_driver = "pgsql";
            "pgsql /run/postgresql" = {
                parameters = {
                    dbname = "mail";
                    user = "dovecot2";
                };
            };
            
            "passdb sql" = {
                query = "SELECT localpart AS username, domain, password_hash AS password FROM users WHERE localpart = '%{user | username}' AND domain = '%{user | domain}' AND enabled";
            };

            "userdb sql" = {
                query = "SELECT '/var/spool/mail/vmail/' || domain || '/' || localpart AS home FROM users WHERE localpart = '%{user | username}' AND domain = '%{user | domain}' AND enabled";
                iterate_query = "SELECT localpart AS username, domain FROM users WHERE enabled";
            };

            "namespace inbox" = {
                inbox = true;
                "mailbox Drafts" = { auto = "create"; special_use = "\\Drafts"; };
                "mailbox Sent" = { auto = "create"; special_use = "\\Sent"; };
                "mailbox Trash" = { auto = "create"; special_use = "\\Trash"; };
                "mailbox Junk" = { auto = "create"; special_use = "\\Junk"; };
            };

            "service auth" = {
                "unix_listener ${postfixQueue}/private/auth" = {
                    user = "postfix";
                    group = "postfix";
                    mode = "0660";
                };
            };

            "service lmtp" = {
                "unix_listener ${postfixQueue}/private/dovecot-lmtp" = {
                    user = "postfix";
                    group = "postfix";
                    mode = "0660";
                };
            };
        };
    };
}