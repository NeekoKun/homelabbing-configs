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

{
  description = "NixOS configuration for my homeserver";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, agenix, ... }:
    let
      vars = {
        services = {
          prometheus = {
            http_port = 9696;
          };

          loki = {
            http_port = 3100;
            grpc_port = 9096;
          };

          grafana = {
            port = 2342;
          };

          navidrome = {
            http_port = 4533;
          };

          synapse = {
            http_port = 8008;
          };

          coturn = {
            port = 3478;
            tls_port = 3480;
          };

          vaultwarden = {
            http_port = 8222;
          };
        };

        network = {
          DNS = {
            domain = "neekokun";
            tld = "com";
            token = "9c347773-7657-4258-88e1-5ff06eab805e";
          };

          interfaces = {
            wan = "enp0s9";
            lan = "enp0s3";
          };

          internal = {
            istanbul = "192.168.2.1";
            rome = "192.168.2.2";
            babylon = "192.168.2.3";
            alexandria = "192.168.2.4";
            subnet  = "192.168.2.0/24";
            mask = "255.255.255.0";
          };
        };
      };

      mkHost = name: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit vars;
          flakeRoot = ./.;
        };
        modules = [
          agenix.nixosModules.default
          ./configuration.nix
          ./hosts/${name}/default.nix
        ];
      };
    in
    {
      nixosConfigurations = {

        # Gateway Configs
        istanbul = mkHost "istanbul";

        # Data Aggregation Configs
        rome = mkHost "rome";

        # Synapse Configs
        babylon = mkHost "babylon";

        # Navidrome + Nextcloud + Vaultwarden Configs
        alexandria = mkHost "alexandria";
      };
    };
}

