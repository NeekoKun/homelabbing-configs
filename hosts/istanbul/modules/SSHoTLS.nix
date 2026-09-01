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

{ config, pkgs, vars, ... }:

let
    net = vars.network;
in
{
  services.stunnel = {
    enable = true;

    servers.ssh = {
        accept =  "127.0.0.1:8022";
        connect = "127.0.0.1:2222";
        cert    = "/var/lib/acme/contacts.${net.DNS.domain}.${net.DNS.tld}/fullchain.pem";
        key     = "/var/lib/acme/contacts.${net.DNS.domain}.${net.DNS.tld}/key.pem";
    };
  };

  services.sslh = {
    enable = true;

    listenAddresses = [ "127.0.0.1" ];
    port = 2222;

    settings = {
      protocols = [
        { name = "ssh"; host = "localhost"; port = "22"; }
        { name = "tls"; host = "localhost"; port = "8222"; }
      ];
    };
  };
}