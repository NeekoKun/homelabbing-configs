{ config, vars, ... }:

{
  services.prometheus = {
    enable = true;
    port = vars.services.prometheus.port;

    extraFlags = [
      "--web.enable-remote-write-receiver";
      "--web.listen-address=0.0.0.0:${toString vars.services.prometheus.http_port}";
    ];
  };
}
