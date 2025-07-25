{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
in
{
  imports = [
    #./swaync.nix
    ./waybars
    ./rofi
    ./cliphist.nix
    #./hyprlock.nix
    #./hypridle.nix
  ];
  home.packages = mkIf cfg.wayland.enable (
    with pkgs;
    [
      meson
      wayland-protocols
      wayland-utils
      wlroots
      swww
      wl-clipboard
    ]
  );

  services.playerctld.enable = cfg.wayland.enable;
}
