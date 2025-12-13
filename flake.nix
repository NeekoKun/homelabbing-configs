{
  description = "NixOS configuration for my homeserver";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations = {

      # Gateway Configs
      gateway = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hosts/gateway/default.nix
        ];
      };

      # Loki Configs
      loki = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hosts/loki/default.nix
        ];
      };

      # Synapse
      synapse = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hosts/synapse/default.nix
        ];
      };
    };
  };
}

