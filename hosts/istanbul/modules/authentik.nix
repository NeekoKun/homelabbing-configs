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

{ config, vars, flakeRoot, ...}:

{
    age.secrets.authentikSecrets.file = "${flakeRoot}/secrets/authentik-secrets.age";

    services.authentik = {
        enable = true;
        
        environmentFile = config.age.secrets.authentikSecrets.path;

        settings = {
            disable_startup_analytics = true;
            avatars = "initials";
        };

        nginx = {
            enable = true;

            enableACME = true;
            host = "auth.${vars.network.DNS.domain}.${vars.network.DNS.tld}";
        };
    };
}