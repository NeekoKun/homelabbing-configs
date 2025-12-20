{ vars, ... }:

{
  # Mount Music drive (/dev/sdb)
  #TOCHANGE
  fileSystems."/mnt/music" = {
    device = "/dev/sdb";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  services.navidrome = {
    enable = true;

    settings = {
      MusicFolder = "/mnt/music";
      DataFolder = "/var/lib/navidrome";
      Address = "0.0.0.0";
      Port = vars.services.navidrome.http_port;
    };
  };

  systemd.services.navidrome = {
    after = [ "mnt-music.mount" ];
    requires = [ "mnt-music.mount" ];
  };
}
