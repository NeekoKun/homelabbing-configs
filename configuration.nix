# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, vars, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./secrets.nix
      ./nixos/default.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "video=1920x1200" ];

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  ## USELESS: Using kmscon, set as fallback IN CASE
  console = {
    font = "Lat2-Terminus16";
    keyMap = "it";
  };

  systemd.services."getti@tty1".enable = false;

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "1234";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPrhbe8Ow3i9PXPcBqI/X/MAv4tcJd0io7kA3Ku4AKkF neeko@arch"
    ];
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
    gh
    jq
    stress-ng
    tshark
    dig
    mlocate
    
    # Monitoring
    usbutils
    pciutils
    btop
    htop
    fastfetch
  ];
  system.stateVersion = "25.11";
}
