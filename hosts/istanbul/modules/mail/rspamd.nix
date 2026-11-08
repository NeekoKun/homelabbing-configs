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

{ config, ... }:

{
    services.redis.servers.rspamd = {
        enable = true;
        user = config.services.rspamd.user;
        port = 0;
    };

    services.rspamd = {
        enable = true;
        postfix.enable = true;

        locals = {
            "redis.conf".text = ''
                servers = "/run/redis-rspamd/redis.sock";
            '';

            "dkim_signing.conf".text = ''
                path = "/var/lib/rspamd/dkim/$domain.$selector.key";
                selector = "s2026";
                allow_username_mismatch = true;
                sign_authenticated = true;
                sign_local = true;
            '';
        };
    };
}