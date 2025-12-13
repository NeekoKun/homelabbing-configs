{ vars, ... }:

{
  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_port = vars.services.grafana.port;
        http_addr = "127.0.0.1";
      };
    };
  };
}
