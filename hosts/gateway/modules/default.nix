{ vars }:

{
  imports = [
    ( import ./suricata.nix { inherit vars; })
  ];
}
