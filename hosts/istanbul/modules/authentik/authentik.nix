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

{ config, vars, pkgs, lib, flakeRoot, ...}:

let
    mergedBlueprints = pkgs.runCommandLocal "authentik-blueprints-merged" {} ''
        mkdir -p $out/custom

        cp -rL ${config.services.authentik.authentikComponents.staticWorkdirDeps}/blueprints/. $out/

        cp -rL ${./blueprints}/. $out/custom/
    '';
in
{
    age.secrets.authentikSecrets.file = "${flakeRoot}/secrets/authentik-secrets.age";

    imports = [ ../nginx.nix ];

    services.authentik = {
        enable = true;
        
        environmentFile = config.age.secrets.authentikSecrets.path;

        settings = {
            disable_startup_analytics = true;
            avatars = "initials";

            blueprints_dir = mergedBlueprints;
        };
    };

    systemd.services = lib.genAttrs [ "authentik-worker" "authentik-migrate" "authentik" ] (_: {
        environment._AUTHENTIK_LDAP_BASE_DN = "dc=${vars.network.DNS.domain},dc=${vars.network.DNS.tld}";
    });
    
    services.nginx.virtualHosts."auth.${vars.network.DNS.domain}.${vars.network.DNS.tld}" = config.my.nginx.commonVHost // {
        locations."/" = {
            proxyPass = "http://127.0.0.1:9000";
            proxyWebsockets = true;
            recommendedProxySettings = true;
            extraConfig = ''
                proxy_set_header Host $host;
            '';
        };
    };
}