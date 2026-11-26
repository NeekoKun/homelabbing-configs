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

{ config, lib, pkgs, vars, flakeRoot, ... }:

{
  age.secrets.ssh-key-manager-password = {
    file = "${flakeRoot}/secrets/ssh-key-manager-password.age";
    owner = "nobody";
    mode = "0400";
  };

  services.ssh-key-manager = {
    enable = true;
    logFile = "/var/log/key-manager.log";

    database = {
      host = "127.0.0.1";
      user = "key-manager";
      name = "key-manager";
      passwordFile = config.age.secrets.ssh-key-manager-password.path;
    };

    baseKeys = [
      {
        localUser = "admin";
        fingerprint = "SHA256:VQhm/AHZdksz5FsQvZ583wpvM1oi0GATEsJz1FHOzc4";
        keyType = "ssh-ed25519";
        publicKey = "AAAAC3NzaC1lZDI1NTE5AAAAIP1SORqrVF2xg0MlOIi9xT82lBal98BPipIuHZIpQMfN";
      }
    ];
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "key-manager" ];
    ensureUsers = [
      {
        name = "key-manager";
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services.postgresql-setup.postStart = lib.mkAfter ''
    KEY_MANAGER_DB_PASSWORD="$(cat ${config.age.secrets.ssh-key-manager-password.path})" || exit 1
    if [ -z "$KEY_MANAGER_DB_PASSWORD" ]; then
      echo "ssh-key-manager database password secret is empty" >&2
      exit 1
    fi
    export KEY_MANAGER_DB_PASSWORD

    ${config.services.postgresql.package}/bin/psql -X -d postgres -v ON_ERROR_STOP=1 <<'SQL' || exit 1
    \getenv key_manager_password KEY_MANAGER_DB_PASSWORD
    SELECT format('ALTER ROLE "key-manager" WITH PASSWORD %L', :'key_manager_password') \gexec
    SQL

    unset KEY_MANAGER_DB_PASSWORD
  '';

  services.openssh = {
    enable = true;
    openFirewall = false;
    listenAddresses = [
      {
        addr = "127.0.0.1";
        port = 22;
      }
      {
        addr = "0.0.0.0";
        port = 4343;
      }
    ];

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };

    extraConfig = ''
      X11Forwarding no
      AllowAgentForwarding yes
      AllowTcpForwarding yes
    '';
  };

  # fwknop
  environment.systemPackages = [ pkgs.fwknop ];

  environment.etc."fwknop/fwknopd.conf".text = ''
    PCAP_INTF           ${vars.network.interfaces.wan};
  '';

  environment.etc."fwknop/access.conf".text = ''
    SOURCE                     ANY
    OPEN_PORTS                 tcp/4343
    REQUIRE_SOURCE_ADDRESS     Y
    KEY_BASE64:                gqaTtYZo0dcpqzCGoi2UcN+3pXFsFjXY+UX1zWyo8gg=
    HMAC_KEY_BASE64:           ox1wj7xySrYSV/Y+BgEBCc9zuEEjITzy0gdHJKjgypUjI5xJ+skbr9OX+LnOGTD1BbYACQz4O89aYURHfhglfQ==
  '';

  systemd.services.fwknopd = {
    description = "fwknopd SPA daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.fwknop}/bin/fwknopd --conf /etc/fwknop/fwknopd.conf --foreground";
      Restart = "on-failure";
    };
  };
}
