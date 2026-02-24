{ config, pkgs, ... }: 

{
  environment.systemPackages = [ pkgs.synapse-admin-etkecc ];

  systemd.services.synapse-admin-local = {
    description = "Local Synapse Admin Server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.darkhttpd}/bin/darkhttpd ${pkgs.synapse-admin-etkecc} --port 8080 --addr 127.0.0.1";
      Restart = "always";
    };
  };
}
