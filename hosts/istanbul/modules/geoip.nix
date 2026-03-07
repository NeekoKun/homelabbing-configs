{ config, vars, flakeRoot, ... }:

{
  age.secrets.maxmind-license-key.file = "${config.flakeRoot}/secrets/maxmind-license-key.age";

  services.geoipupdate = {
    enable = true;

    settings = {
      AccountID = 1309665;
      LicenseKey = config.age.secrets.maxmind-license-key.file;
      DatabaseDirectory = "/var/lib/geoip";
      EditionIDs = [ "GeoLite2-City" ];
    };
  };
}