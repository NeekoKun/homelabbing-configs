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

{ config, lib, pkgs, vars, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 4343 ];

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };

    extraConfig = ''
      X11Forwarding no
      AllowAgentForwarding yes
      AllowTcpForwarding yes
    '';
  };

  services.fail2ban = {
    enable = true;

    bantime-increment = {
      enable = true;
      formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      maxtime = "168h";
      overalljails = true;
    };

    jails = {
      apache-nohome-iptables.settings = {
        # Block an IP address if it accesses a non-existent
        # home directory more than 5 times in 10 minutes,
        # since that indicates that it's scanning.
        filter = "apache-nohome";
        action = ''iptables-multiport[name=HTTP, port="http,https"]'';
        logpath = "/var/log/httpd/error_log*";
        backend = "systemd";
        findtime = 600;
        bantime  = 600;
        maxretry = 5;
      };

      sshd.settings = {
        enabled = true;
        port = "4343";
        backend = "systemd";
        filter = "sshd";
        maxretry = 5;
        bantime = "1h";
      };
    };
  };
}
