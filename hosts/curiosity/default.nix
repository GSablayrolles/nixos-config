{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./network.nix
    ../shared/content/stylix.nix
    ../shared/global
    ../shared/users/guillaume
    ./sops.nix
  ];

  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;

      theme = "sddm-astronaut-theme";
      extraPackages = [ pkgs.sddm-astronaut ];
    };
    xserver = {
      enable = true;
      xkb.layout = "fr";
    };
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
    postgresql = {
      enable = true;
      package = pkgs.postgresql_17;
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

  environment.systemPackages = with pkgs; [
    xdg-utils # xdg-open
    sddm-astronaut
  ];
}
