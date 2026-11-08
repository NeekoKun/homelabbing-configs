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

{ ... }:

{
    services.fail2ban = {
        enable = true;

        jails = {
            dovecot.settings = {
                enabled = true;
                filter = "dovecot";
                backend = "systemd";
                journalmatch = "_SYSTEMD_UNIT=dovecot.service";
                port = "993";
                maxretry = 5;
            };

            postfix.settings = {
                enabled = true;
                filter = "postfix[mode=auth]";
                backend = "systemd";
                journalmatch = "_SYSTEMD_UNIT=postfix.service";
                port = "465";
                maxretry = 5;
            };
        };
    };
}