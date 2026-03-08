# Copyright (C) 2026 NeekoKun
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

let
  admin    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJfzL8Ntzf3gn7hbnn1ddOng+cQJd5nRl7HqWASW3Rcw admin@istanbul";
  
  istanbul = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOCBrszJ63yn00uV3kTjNXp9EfezBLXCD8agN4neVUAz root@istanbul";
  rome     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0yYswP+ivHjRZmM25CIhgN0AsDz+qJfRzuQdPZ6Q5Q root@rome";
  babylon  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEz/MWFcawlr329O1dCeuQo/fDWXLwbybgJRZAaaOXi root@babylon";
  alexandria   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICFKu+epULjNWFQRLVqMWb9+O0QNbLimHu648QvPM6Vn root@alexandria";

  allHosts = [ admin istanbul rome babylon alexandria ];
in
{
  "admin-password.age".publicKeys = allHosts;
  "cloudflare-env.age".publicKeys = [ admin istanbul ];
  "maxmind-license-key.age".publicKeys = [ admin istanbul ];
  "coturn-secret.age".publicKeys = [ admin istanbul babylon ];
  "nextcloud-admin-password.age".publicKeys = [ admin alexandria ];
  "vaultwarden-env.age".publicKeys = [ admin alexandria ];
}
