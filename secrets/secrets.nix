let
  istanbul = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOCBrszJ63yn00uV3kTjNXp9EfezBLXCD8agN4neVUAz root@istanbul";
  rome = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOAuamfT84R1+iKoPVCyPTj5akLhzJr/l0PGg9F7x/tF admin@rome";
  thebes = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPR/TfhkCvtiRbEgxGpomCWWI7rGL/YV0L76sVeBXtdD admin@thebes";

  allHosts = [ istanbul rome thebes ];
in
{
  "admin-password.age".publicKeys = allHosts;
  "grafana-secret.age".publicKeys = [ rome ];
  "navidrome-secret.age".publicKeys = [ thebes ];
}
