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

{ config, pkgs, vars, inputs, lib, flakeRoot, ... }:

let
    domain = vars.network.DNS.domain;
    tld = vars.network.DNS.tld;
in
{
    options.my.nginx.commonVHost = lib.mkOption {
        type = lib.types.attrs;
        readOnly = true;
        description = "Settings applied to every proxied service vhost.";
        default = {
            useACMEHost = "${domain}.${tld}";
            forceSSL = true;
            listen = [ { addr = "0.0.0.0"; port = 443; ssl = true; } ];
        };
    };

    config = {
        environment.systemPackages = with pkgs; [
            nginx
        ];

        services.nginx = {
            enable = true;

            recommendedTlsSettings = true;
            recommendedOptimisation = true;
            recommendedGzipSettings = true;
            recommendedProxySettings = true;
            logError = "stderr debug";

            appendHttpConfig = ''
                log_format json_combined escape=json
                    '{'
                        '"time_local":"$time_local",'
                        '"remote_addr":"$remote_addr",'
                        '"request":"$request",'
                        '"status":$status,'
                        '"body_bytes_sent":$body_bytes_sent,'
                        '"http_referer":"$http_referer",'
                        '"http_user_agent":"$http_user_agent",'
                        '"http_x_forwarded_for":"$http_x_forwarded_for",'
                        '"request_time":$request_time'
                    '}';

                access_log /var/log/nginx/access.log json_combined;
            '';

            virtualHosts = {
                "navidrome.${vars.network.DNS.domain}.${vars.network.DNS.tld}" = {
                    http2 = true;
                    http3 = true;
                    quic = true;
                    reuseport = true;

                    extraConfig = ''
                        add_header Alt-Svc 'h3=":443"; ma=86400' always;
                    '';

                    locations."/" = {
                            proxyPass = "http://127.0.0.1:${toString vars.services.navidrome.http_port}/";
                    };
                };

                "wiki.${domain}.${tld}" = config.my.nginx.commonVHost // {
                    root = inputs.myWiki.packages.x86_64-linux.wiki;

                    locations."/" = {
                        tryFiles = "$uri $uri/ $uri.html =404";
                        index = "index.html";
                    };
                };

                "contacts.${domain}.${tld}" = {
                    listen = [ { addr = "127.0.0.1"; port = 8222; } ];
                    locations."/" = {
                        return = "302 https://${domain}.${tld}/contacts";
                        #root = "/var/www/contacts.${domain}.${tld}";
                    };
                };

                "ssh-fallback" = {
                    listen = [ { addr = "127.0.0.1"; port = 8222; ssl = false;} ];
                    locations."/" = {
                        return = "302 https://${domain}.${tld}/contacts";
                    };
                };

                "${domain}.${tld}" = config.my.nginx.commonVHost // {
                    default = true;

                    locations."/.well-known/matrix/server" = {
                        return = ''200 "{\"m.server\": \"matrix.${domain}.${tld}:443\"}"'';
                        extraConfig = ''
                            add_header Content-Type application/json;
                        '';
                    };

                    locations."/.well-known/matrix/client" = {
                        return = ''200 "{\"m.homeserver\": {\"base_url\": \"https://matrix.${domain}.${tld}\"}}"'';
                        extraConfig = ''
                            add_header Content-Type application/json;
                            add_header Access-Control-Allow-Origin *;
                        '';
                    };
                };
            };
        };

        systemd.services.nginx.serviceConfig = {
            StartLimitIntervalSec = 0; # Avoid STUPID crash due to restarts
        };

        age.secrets.cloudflareAcme.file = "${flakeRoot}/secrets/cloudflare-acme.age";

        security.acme = {
            acceptTerms = true;

            defaults = {
                email = "neekokun@proton.me";
                dnsProvider = "cloudflare";
                extraLegoFlags = [ "--dns.propagation-wait" "60s" ];
                credentialFiles = {
                    CLOUDFLARE_DNS_API_TOKEN_FILE = config.age.secrets.cloudflareAcme.path;
                };
            };

            certs."${domain}.${tld}" = {
                domain = "*.${domain}.${tld}";
                extraDomainNames = [ "${domain}.${tld}" ];
                group = "nginx";
            };

            certs."navidrome.${domain}.${tld}" = {
                domain = "navidrome.${domain}.${tld}";
                group = "hysteria";
                postRun = ''
                    systemctl restart hysteria.service
                '';
            };

            certs."mail.${domain}.${tld}" = {
                domain = "mail.${domain}.${tld}";
                group = "mailcerts";

                reloadServices = [ "postfix.service" "dovecot2.service" ];
            };
        };
    };
}
