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
    ./homelab.nix
    ../shared/users/guillaume
    ../shared/global
    ../shared/content/stylix.nix
    ../shared/content/homelab

  ];

  networking = {
    hostName = "iss";

    domain = "ferrets-home.party";
    search = [ "ferrets-home.party" ];

    extraHosts = ''
      192.168.1.134 atlantis
    '';

    firewall = {
      enable = true;

      allowedUDPPorts = [ 53 ];
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
