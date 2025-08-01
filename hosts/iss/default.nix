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
    ../shared/users/guillaume
    ../shared/global
    ../shared/content/stylix.nix
    ../shared/content/homelab

  ];
  networking.hostName = "iss";
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
    # package = config.boot.kernelPackages.nvidiaPackages.beta.overrideAttrs (old: let
    #   version = "535.129.03";
    # in {
    #   src = pkgs.fetchurl {
    #     url = "https://download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}.run";
    #     sha256 = "sha256-5tylYmomCMa7KgRs/LfBrzOLnpYafdkKwJu4oSb/AC4=";
    #   };
    # });

    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 81 ];
      allowedUDPPorts = [ 53 ];
    };
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
