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

{ config, vars, pkgs, ... }:

let
    mailHost = "mail.${vars.network.DNS.domain}.${vars.network.DNS.tld}";
    certDir = config.security.acme.certs.${mailHost}.directory;
in
{
    users.groups.mailcerts = {};
    users.users.postfix.extraGroups = [ "mailcerts" ];

    services.postfix = {
        enable = true;
        enableSubmission = true;
        enableSubmissions = true;

        settings.main = {
            myhostname = mailHost;
            mydomain = "${vars.network.DNS.domain}.${vars.network.DNS.tld}";
            mydestination = [ "${vars.network.DNS.domain}.${vars.network.DNS.tld}" "localhost" ];
            smtpd_tls_chain_files = [ "${certDir}/fullchain.pem" "${certDir}/key.pem" ];
        };
    };

    systemd.services.postfix = {
        wants = [ "acme-finished-${mailHost}.target" ];
        after = [ "acme-finished-${mailHost}.target" ];
    };
}