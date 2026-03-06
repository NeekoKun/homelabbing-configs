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
