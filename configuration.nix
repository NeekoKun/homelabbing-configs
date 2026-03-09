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

{ config, lib, pkgs, vars, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./nixos/default.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Cleanup old Generations
  systemd.services.nix-delete-old = {
    description = "Delete old Nix generations";
    after = [ "nix-daemon.service" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.nix}/bin/nix-env --delete-generations +5";
    };
  };

  systemd.timers.nix-delete-old = {
    description = "Timer for deleting old Nix generations";

    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  # Make user configuration immutable (forces password from hashedPasswordFile)
  users.mutableUsers = false;

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

  age.secrets.adminPassword.file = ./secrets/admin-password.age;

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.age.secrets.adminPassword.path;
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
    fio
    
    # Monitoring
    usbutils
    pciutils
    btop
    htop
    fastfetch
  ];
  system.stateVersion = "25.11";
}
