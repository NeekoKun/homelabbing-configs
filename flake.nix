{
  description = "NixOS configuration for my homeserver";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      vars = {
        services = {
          loki = {
            http_listen_port = 3100;
            grpc_listen_port = 9096;
          };

          grafana = {
            port = 2342;
          };
        };

        network = {
          interfaces = {
            wan = "enp0s8";
            lan = "enp0s3";
          };

          internal = {
            gateway = "192.168.2.1";
            loki = "192.168.2.2";
            synapse = "192.168.2.3";
            navidrome = "192.168.2.4";
            nextcloud = "192.168.2.5";
            subnet  = "192.168.2.0/24";
            mask = "255.255.255.0";
          };
        };
      };
    in
    {
      nixosConfigurations = {

        # Gateway Configs
        gateway = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit vars; };
          modules = [
            ./configuration.nix
            ./hosts/gateway/default.nix
          ];
        };

        # Loki Configs
        loki = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit vars; };
          modules = [
            ./configuration.nix
            ./hosts/loki/default.nix
          ];
        };

        # Synapse
        synapse = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit vars; };
          modules = [
            ./configuration.nix
            ./hosts/synapse/default.nix
          ];
        };
      };
    };
  };
}

