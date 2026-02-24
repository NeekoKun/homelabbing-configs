{ config, pkgs, lib, vars, flakeRoot, ... }:

let 

in
{
  services.matrix-synapse = {
    enable = true;
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

      age.secrets.synapseSecret.file = "${flakeRoot}/secrets/synapse-secret.age";

      enable_registration = true;
      registration_requires_token = true;
      registration_shared_secret = age.secrets.synapseSecret.content;
    };
  };
}
