{ vars }:

{
  imports = [
    ( import ./networking.nix      { inherit vars; })
    ( import ./modules/default.nix { inherit vars; })
  ];
}
