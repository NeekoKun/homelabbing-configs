{{ pkgs, vars, ... }:

let
  net = vars.network;
in
{
  services.httpd = {
    enable = true;
    listen = [{ port = 8080; }];
    virtualHosts."localhost" = {
      documentRoot = "/var/www/html";
    };
  }:
}
