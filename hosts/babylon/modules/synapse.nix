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

{ config, pkgs, lib, vars, flakeRoot, ... }:

{
  age.secrets.coturnSecret = {
    file = "${flakeRoot}/secrets/coturn-secret.age";
    owner = "matrix-synapse";
  };

  systemd.services.matrix-synapse.serviceConfig.ExecStartPre = let
    script = pkgs.writeShellScript "synapse-secret-setup" ''
      echo "registration_shared_secret: \"$(cat ${config.age.secrets.coturnSecret.path})\"" \
        > /run/matrix-synapse/secret.yaml
      chown matrix-synapse /run/matrix-synapse/secret.yaml
      chmod 400 /run/matrix-synapse/secret.yaml
    '';
  in [ "+${script}" ];

  services.matrix-synapse = {
    enable = true;
    extraConfigFiles = [ "/run/matrix-synapse/secret.yaml" ];
    settings = {
      server_name = "${vars.network.DNS.domain}.${vars.network.DNS.tld}";
      public_baseurl = "https://matrix.${vars.network.DNS.domain}.${vars.network.DNS.tld}";
      cors_allow_origin = [ "http://localhost:8080" ]; # Prevent matrix from blocking admin console changes

      turn_uris = [
        "turn:turn.${vars.network.DNS.domain}.${vars.network.DNS.tld}:${toString vars.services.coturn.port}?transport=udp"
        "turn:turn.${vars.network.DNS.domain}.${vars.network.DNS.tld}:${toString vars.services.coturn.port}?transport=tcp"
        "turns:turn.${vars.network.DNS.domain}.${vars.network.DNS.tld}:${toString vars.services.coturn.tls_port}?transport=udp"
        "turns:turn.${vars.network.DNS.domain}.${vars.network.DNS.tld}:${toString vars.services.coturn.tls_port}?transport=tcp"
      ];
      
      turn_shared_secret = "passwordMoltoSicura"; # TODO: age-encrypt
      turn_user_lifetime = "1h";

      url_preview_enabled = true;
      url_preview_ip_range_blacklist = [ "127.0.0.0/8" "10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16" ];

      listeners = [
        {
          port = vars.services.synapse.http_port;
          bind_addresses = [ "0.0.0.0" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [ "client" "federation" ];
              compress = false;
            }
          ];
        }
      ];

      enable_registration = true;
      registration_requires_token = true;
      registration_shared_secret = "passwordMoltoSicura"; # TODO: age-encrypt
    };
  };

  environment.systemPackages = [ pkgs.matrix-synapse ];
}
