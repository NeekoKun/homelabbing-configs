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
        enableSubmission = false;
        enableSubmissions = true;

        settings.main = {
            myhostname = mailHost;
            mydomain = "${vars.network.DNS.domain}.${vars.network.DNS.tld}";
            mydestination = [ "$mydomain" "localhost" ];
            smtpd_tls_chain_files = [ "${certDir}/key.pem" "${certDir}/fullchain.pem" ];

            # Protocols
            smtpd_tls_protocols = ">=TLSv1.2";
            smtpd_tls_mandatory_protocols = ">=TLSv1.2";
            smtp_tls_protocols = ">=TLSv1.2";
            smtp_tls_mandatory_protocols = ">=TLSv1.2";

            # Ciphers
            tls_high_cipherlist = "ECDHE+AESGCM:ECDHE+CHACHA20"; # No obsolete CBC Ciphers
            smtpd_tls_ciphers = "high";
            smtpd_tls_mandatory_ciphers = "high";
            smtp_tls_ciphers = "high";
            smtp_tls_mandatory_ciphers = "high";
            smtpd_tls_exclude_ciphers = "aNULL, eNULL, EXPORT, DES, 3DES, RC4, MD5, PSK, SRP, SEED, IDEA, CAMELLIA";
            smtpd_tls_mandatory_exclude_ciphers = "aNULL, eNULL, EXPORT, DES, 3DES, RC4, MD5, PSK, SRP, SEED, IDEA, CAMELLIA";
            smtp_tls_exclude_ciphers = "aNULL, eNULL, EXPORT, DES, 3DES, RC4, MD5, PSK, SRP, SEED, IDEA, CAMELLIA";
            smtp_tls_mandatory_exclude_ciphers = "aNULL, eNULL, EXPORT, DES, 3DES, RC4, MD5, PSK, SRP, SEED, IDEA, CAMELLIA";

            smtpd_tls_security_level = "may";
            smtp_tls_security_level = "may";
            smtpd_tls_auth_only = true;
            smtpd_tls_loglevel = "1";
            smtp_tls_loglevel = "1";

            # Relay / recipient / sender hygiene
            smtpd_relay_restrictions = "permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination";
            smtpd_recipient_restrictions = [
                "permit_mynetworks"
                "permit_sasl_authenticated"
                "reject_non_fqdn_recipient"
                "reject_unknown_recipient_domain"
                "reject_unauth_destination"
            ];
            smtpd_sender_restrictions = [
                "reject_non_fqdn_sender"
                "reject_unknown_sender_domain"
            ];
            smtpd_helo_required = true;

            # Info leaks and abuse limits
            disable_vrfy_command = true;
            smtpd_banner = "$myhostname ESMTP";
            smtpd_client_connection_rate_limit = 30;
            smtpd_client_message_rate_limit = 30;
            smtpd_client_recipient_rate_limit = 100;
            smtpd_hard_error_limit = 5;
            smtpd_error_sleep_time = "5s";

            inet_protocols = "ipv4";  # until AAAA/PTR/SPF cover IPv6
        };

        submissionsOptions = {
            syslog_name = "postfix/submissions";
            milter_macro_daemon_name = "ORIGINATING";
            smtpd_tls_wrappermode = "yes";
            smtpd_tls_security_level = "encrypt";
            smtpd_tls_auth_only = "yes";
            smtpd_tls_mandatory_protocols = ">=TLSv1.3";
            smtpd_sasl_auth_enable = "yes";
            smtpd_sasl_security_options = "noanonymous";
            smtpd_client_restrictions = "permit_sasl_authenticated,reject";
            smtpd_relay_restrictions = "permit_sasl_authenticated,reject";
            smtpd_etrn_restrictions = "reject";
        };
    };

    systemd.services.postfix = {
        wants = [ "acme-finished-${mailHost}.target" ];
        after = [ "acme-finished-${mailHost}.target" ];
    };
}