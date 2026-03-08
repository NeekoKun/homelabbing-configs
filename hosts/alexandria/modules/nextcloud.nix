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

{ config, vars, flakeRoot, pkgs, ... }:


{
  age.secrets.nextcloudAdminPassword = {
    file = "${flakeRoot}/secrets/nextcloud-admin-password.age";
    owner = "nextcloud";
  };

  services.nginx.enable = true;

  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.${vars.network.DNS.domain}.${vars.network.DNS.tld}";

    package = pkgs.nextcloud32;

    https = false;
    config = {
      adminpassFile = config.age.secrets.nextcloudAdminPassword.path;
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbname = "nextcloud";
      dbhost = "/run/postgresql";
    };

    settings = {
      overwriteprotocol = "https";
      trusted_domains = [
        vars.network.internal.istanbul
        vars.network.internal.alexandria
      ];
      trusted_proxies = [ vars.network.internal.istanbul ];
    };

    # Enable CalDAV and CardDAV
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
    };
    extraAppsEnable = true;
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };

  # Ensure PostgreSQL is running before NextCloud setup
  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };
}
