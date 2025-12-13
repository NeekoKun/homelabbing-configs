{ vars }:

{
  imports = [
    (import ./networking.nix { inherit vars; })
  ];
}
