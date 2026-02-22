{ config, vars, ... }:

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

      ND_DEFAULTADMIN_USERNAME = "admin";
      ND_DEFAULTADMIN_PASSWORD = "1234";
    }; #TODO add Prometheus endpoint, add default admin user account
  };

  systemd.services.navidrome = {
    after = [ "mnt-music.mount" ];
    requires = [ "mnt-music.mount" ];
  };
}
