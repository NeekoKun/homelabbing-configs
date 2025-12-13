{ vars }:

{
  imports = [
    ( import ./suricata.nix { inherit vars; })
    ( import ./vector.nix   { inherit vars; })
  ];
}
