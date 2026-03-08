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
  services.postgresql = {
    enable = true;

    initialScript = pkgs.writeText "synapse-pg-init" ''
    CREATE ROLE "matrix-synapse" LOGIN;
    CREATE DATABASE "matrix-synapse"
      WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = 'C'
      LC_CTYPE = 'C';
    '';
  };
}
