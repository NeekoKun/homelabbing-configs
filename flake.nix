{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };
  outputs = inputs@{ self, nixpkgs, ... }: {

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ];
    };
  };
}

