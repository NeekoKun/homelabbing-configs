{
  description = "NixOS configuration for my homeserver";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, agenix, ... }:
    let
      vars = {
        services = {
          prometheus = {
            http_port = 9696;
          };

          loki = {
            http_port = 3100;
            grpc_port = 9096;
          };

          grafana = {
            port = 2342;
          };

          navidrome = {
            http_port = 4533;
          };

          synapse = {
            http_port = 8008;
          };

          coturn = {
            port = 3478;
            tls_port = 3480;
          };

          vaultwarden = {
            http_port = 8222;
          };
        };

        network = {
          DNS = {
            domain = "neekokun";
            tld = "com";
            token = "9c347773-7657-4258-88e1-5ff06eab805e";
          };

          interfaces = {
            wan = "enp0s9";
            lan = "enp0s3";
          };

          internal = {
            istanbul = "192.168.2.1";
            rome = "192.168.2.2";
            babylon = "192.168.2.3";
            alexandria = "192.168.2.4";
            subnet  = "192.168.2.0/24";
            mask = "255.255.255.0";
          };
        };
      };

      mkHost = name: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit vars;
          flakeRoot = ./.;
        };
        modules = [
          agenix.nixosModules.default
          ./configuration.nix
          ./hosts/${name}/default.nix
        ];
      };
    in
    {
      nixosConfigurations = {

        # Gateway Configs
        istanbul = mkHost "istanbul";

        # Data Aggregation Configs
        rome = mkHost "rome";

        # Synapse Configs
        babylon = mkHost "babylon";

        # Navidrome + Nextcloud + Vaultwarden Configs
        alexandria = mkHost "alexandria";
      };
    };
}

