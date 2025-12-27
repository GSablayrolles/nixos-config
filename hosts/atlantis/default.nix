{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ../shared/users/guillaume
    ../shared/global
    ../shared/content/stylix.nix
  ];

  networking = {
    hostName = "atlantis";

    domain = "ferret.party";
    search = [ "ferret.party" ];

    extraHosts = ''
      192.168.1.154 iss
    '';

    firewall = {
      enable = true;

    };
  };

  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    xserver = {
      enable = true;
      xkb.layout = "fr";
    };
  };

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  users.users.guillaume.extraGroups = [ "docker" ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is needed for most wayland compositors
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  ## XDG Portals
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
      ];
    };
  };

  environment.systemPackages = [
    pkgs.xdg-utils # xdg-open
    inputs.hyprland-qtutils.packages.${pkgs.system}.default
  ];
}
