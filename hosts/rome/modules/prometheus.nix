{ config, vars, ... }:

{
  services.prometheus = {
    enable = true;
    port = vars.services.prometheus.http_port;

    webExternalUrl = "http://0.0.0.0:${toString vars.services.prometheus.http_port}";
    listenAddress = "0.0.0.0";

    extraFlags = [
      "--web.enable-remote-write-receiver"
      "--storage.tsdb.retention.time=30d"
    ];
  };
}
