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

{ config, vars, ... }:

{
  # Mount music drive (MUSIC-labelled) to /data/music
  fileSystems."/data/music" = {
    device = "/dev/disk/by-label/MUSIC";
    fsType = "ext4";
    options = [
      "nofail"
    ];
  };

  users.groups.music = { };

  users.users.music = {
    isSystemUser = true;
    group = "music";
  };

  systemd.tmpfiles.rules = [
    "d /data/music 2750 music music -"
  ];

  services.navidrome = {
    enable = true;

    settings = {
      MusicFolder = "/data/music";
      DataFolder = "/var/lib/navidrome";
      Address = "0.0.0.0";
      Port = vars.services.navidrome.http_port;

      EnableCoverAnimation = true;
      EnableStarRating = true;
      EnableUserEditing = true;

      ND_DEFAULTADMIN_USERNAME = "admin";
      ND_DEFAULTADMIN_PASSWORD = "1234"; # Change this password once logged in for the first time
    }; #TODO: add Prometheus endpoint
  };

  systemd.services.navidrome = {
    serviceConfig.supplementaryGroups = [ "music" ];
    after = [ "data-music.mount" ];
    requires = [ "data-music.mount" ];
  };
}
