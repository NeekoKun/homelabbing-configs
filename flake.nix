{
  description = "NixOS configuration for my homeserver";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
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
        };

        network = {
          DNS = {
            domain = "neekokun";
            tld = "com";
            token = "9c347773-7657-4258-88e1-5ff06eab805e";
          };

          interfaces = {
            wan = "enp0s8";
            lan = "enp0s3";
          };

          internal = {
            istanbul = "192.168.2.1";
            rome = "192.168.2.2";
            babylon = "192.168.2.3";
            thebes = "192.168.2.4";
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
        istanbul = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit vars; };
          modules = [
            ./configuration.nix
            ./hosts/istanbul/default.nix
          ];
        };

        # Data Aggregation Configs
        rome = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit vars; };
          modules = [
            ./hosts/rome/default.nix
            ./configuration.nix
          ];
        };

        # Navidrome
        thebes = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit vars; };
          modules = [
            ./configuration.nix
            ./hosts/thebes/default.nix
          ];
        };

        # Synapse
        babylon = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit vars; };
          modules = [
            ./configuration.nix
            ./hosts/babylon/default.nix
          ];
        };
      };
    };
}

