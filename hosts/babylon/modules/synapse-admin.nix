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

{ config, pkgs, ... }: 

{
  environment.systemPackages = [ pkgs.synapse-admin-etkecc ];

  systemd.services.synapse-admin-local = {
    description = "Local Synapse Admin Server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.darkhttpd}/bin/darkhttpd ${pkgs.synapse-admin-etkecc} --port 8080 --addr 127.0.0.1";
      Restart = "always";
    };
  };
}
