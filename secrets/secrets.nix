let
  # Your personal SSH public key (for editing secrets)
  neeko = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPrhbe8Ow3i9PXPcBqI/X/MAv4tcJd0io7kA3Ku4AKkF neeko@arch";

  # Your host's SSH public key (for decrypting at boot)
  # Get this from: cat /etc/ssh/ssh_host_ed25519_key.pub
  istanbul = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJfzL8Ntzf3gn7hbnn1ddOng+cQJd5nRl7HqWASW3Rcw admin@istanbul";
  rome = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOAuamfT84R1+iKoPVCyPTj5akLhzJr/l0PGg9F7x/tF admin@rome";
  thebes = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPR/TfhkCvtiRbEgxGpomCWWI7rGL/YV0L76sVeBXtdD admin@thebes";

  allHosts = [ neeko istanbul rome thebes ];
in {
  "admin-password.age".publicKeys = allHosts;
  "grafana-secret.age".publicKeys = [ neeko rome ];
  "navidrome-secret.age".publicKeys = [ neeko thebes ];
}
