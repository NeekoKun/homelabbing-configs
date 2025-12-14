{ vars, ... }:

let
  net = vars.network;
in
{
  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_port = vars.services.grafana.port;
        http_addr = "0.0.0.0";

        root_url = "https://${net.DNS.domain}.${net.DNS.tld}/";
        serve_from_sub_path = true;
      };

      users = {
        allow_sign_up = false;
      };
    };
  };
}
