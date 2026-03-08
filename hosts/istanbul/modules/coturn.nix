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

{ config, pkgs, vars, flakeRoot, ... }:

{
  age.secrets.coturnSecret = {
    file = "${flakeRoot}/secrets/coturn-secret.age";
    owner = "turnserver";
  };

  services.coturn = {
    enable = true;
    use-auth-secret = true;
    static-auth-secret-file = config.age.secrets.coturnSecret.path;
    realm = "turn.${vars.network.DNS.domain}.${vars.network.DNS.tld}";

    listening-ips = [ "0.0.0.0" ];
    listening-port = vars.services.coturn.port;
    tls-listening-port = vars.services.coturn.tls_port;

    no-tcp-relay = true;
    extraConfig = ''
      no-multicast-peers
      verbose
      external-ip=turn.${vars.network.DNS.domain}.${vars.network.DNS.tld}
    '';
    cert = "/var/lib/acme/turn.${vars.network.DNS.domain}.${vars.network.DNS.tld}/cert.pem";
    pkey = "/var/lib/acme/turn.${vars.network.DNS.domain}.${vars.network.DNS.tld}/key.pem";
  };
}