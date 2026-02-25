{ config, pkgs, vars, ... }:

{
  services.coturn = {
    enable = true;
    use-auth-secret = true;
    static-auth-secret = "passwordMoltoSicura"; # TODO: age-encrypt
    realm = "turn.${vars.network.DNS.domain}.${vars.network.DNS.tld}";

    listening-ips = [ "0.0.0.0" ];
    listening-port = vars.services.coturn.port;
    tls-listening-port = vars.services.coturn.tls_port;

    no-tcp-relay = true;
    extraConfig = "no-multicast-peers";
    cert = "/var/lib/acme/turn.${vars.network.DNS.domain}.${vars.network.DNS.tld}/cert.pem";
    pkey = "/var/lib/acme/turn.${vars.network.DNS.domain}.${vars.network.DNS.tld}/key.pem";
  };
}