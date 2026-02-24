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

  environment.systemPackages = [ pkgs.matrix-synapse ];
}
