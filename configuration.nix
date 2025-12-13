# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
  hostname = "loki";
  vars = {
    services = {
      loki = {
        http_listen_port = 3100;
        grpc_listen_port = 9096;
      };
      grafana = {
        port = 2342;
      };
    };

    network = {
      interfaces = {
        wan = "enp0s8";
        lan = "enp0s3";
      };

      internal = {
        gateway = "192.168.2.1";
        loki = "192.168.2.2";
        synapse = "192.168.2.3";
        navidrome = "192.168.2.4";
        nextcloud = "192.168.2.5";
        subnet  = "192.168.2.0/24";
        mask = "255.255.255.0";
      };
    };
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./nixos/default.nix
      (import ./hosts/${hostname}/default.nix { inherit vars; })
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "video=1920x1200" ];

  networking.hostName = hostname;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  ## USELESS: Using kmscon
  console = {
    font = "Lat2-Terminus16";
    keyMap = "it";
  };

  systemd.services."getti@tty1".enable = false;

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "1234"; #TODO: Hash password
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    tree
    cbonsai
    tmux
    git
    pastel

    # Tools
    python3
    zip
    
    # Monitoring
    usbutils
    pciutils
    btop
    htop
    fastfetch
  ];
  system.stateVersion = "25.11";
}
