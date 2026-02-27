let
  admin    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJfzL8Ntzf3gn7hbnn1ddOng+cQJd5nRl7HqWASW3Rcw admin@istanbul";
  
  istanbul = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOCBrszJ63yn00uV3kTjNXp9EfezBLXCD8agN4neVUAz root@istanbul";
  rome     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0yYswP+ivHjRZmM25CIhgN0AsDz+qJfRzuQdPZ6Q5Q root@rome";
  babylon  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEz/MWFcawlr329O1dCeuQo/fDWXLwbybgJRZAaaOXi root@babylon";
  alexandria   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDeTfqJu6q8Wo13Cp4t7u5Mpr+u9ou8RcOV3lsEDqn45 root@alexandria";

  allHosts = [ admin istanbul rome babylon alexandria ];
in
{
  "admin-password.age".publicKeys = allHosts;
  "cloudflare-env.age".publicKeys = [ admin istanbul ];
  "coturn-secret.age".publicKeys = [ admin istanbul babylon ];
  "grafana-secret.age".publicKeys = [ admin rome ];
  "navidrome-secret.age".publicKeys = [ admin alexandria ];
}
