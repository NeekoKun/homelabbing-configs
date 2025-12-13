{ vars }:

{
  imports = [
    ( import ./loki.nix    { inherit vars; })
    ( import ./vector.nix  { inherit vars; })
    ( import ./grafana.nix { inherit vars; })
  ];
}
