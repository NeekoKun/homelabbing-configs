{ config, pkgs, lib, vars, flakeRoot, ... }:

let 

in
{
  age.secrets.synapseSecret = {
    file = "${flakeRoot}/secrets/synapse-secret.age";
    owner = "matrix-synapse";
  };

  services.matrix-synapse = {
    enable = true;
    #extraConfigFiles = [ config.age.secrets.synapseSecret.path ];
    settings = {
      server_name = "${vars.network.DNS.domain}.${vars.network.DNS.tld}";
      public_baseurl = "https://matrix.${vars.network.DNS.domain}.${vars.network.DNS.tld}";
      cors_allow_origin = [ "http://localhost:8080" ]; # Prevent matrix from blocking admin console changes

      turn_uris = [ "turn:matrix.${vars.network.DNS.domain}.${vars.network.DNS.tld}:3478?transport=udp" ];
      turn_shared_secret = "passwordMoltoSicura"; # TODO: age-encrypt
      turn_user_lifetime = "1h";

      url_preview_enabled = true;
      url_preview_ip_range_blacklist = [ "127.0.0.0/8" "10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16" ];

      listeners = [
        {
          port = vars.services.synapse.http_port;
          bind_addresses = [ "0.0.0.0" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [ "client" "federation" ];
              compress = false;
            }
          ];
        }
      ];

      enable_registration = true;
      registration_requires_token = true;
      registration_shared_secret = "passwordMoltoSicura"; # TODO: age-encrypt
    };
  };

  # VoIP
  services.coturn = {
    enable = true;
    use-auth-secret = true;
    static-auth-secret = "passwordMoltoSicura"; # TODO: age-encrypt
    realm = "matrix.${vars.network.DNS.domain}.${vars.network.DNS.tld}";
    no-tcp-relay = true;
    extraConfig = "no-multicast-peers";
  };

  environment.systemPackages = [ pkgs.matrix-synapse ];
}
