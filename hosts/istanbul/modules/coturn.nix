{ config, pkgs, vars, flakeRoot, ... }:

{
  age.secrets.coturnSecret.file = "${flakeRoot}/secrets/coturn-secret.age";

  services.coturn = {
    enable = true;
    use-auth-secret = true;
    static-auth-secret-file = config.age.secrets.coturnSecret.path;
    realm = "turn.${vars.network.DNS.domain}.${vars.network.DNS.tld}";

    listening-ips = [ "0.0.0.0" ];
    listening-port = vars.services.coturn.port;
    tls-listening-port = vars.services.coturn.tls_port;

    no-tcp-relay = true;
    extraConfig = ''
      no-multicast-peers
      verbose
      external-ip=turn.${vars.network.DNS.domain}.${vars.network.DNS.tld}
    '';
    cert = "/var/lib/acme/turn.${vars.network.DNS.domain}.${vars.network.DNS.tld}/cert.pem";
    pkey = "/var/lib/acme/turn.${vars.network.DNS.domain}.${vars.network.DNS.tld}/key.pem";
  };
}