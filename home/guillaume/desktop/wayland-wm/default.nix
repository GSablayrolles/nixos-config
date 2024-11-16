
{
  config, lib, pkgs, ...
}: let
  inherit (lib);
in {
  imports = [
    #./swaync.nix
    ./waybar.nix
    ./rofi
    ./cliphist.nix
    #./hyprlock.nix
    #./hypridle.nix
  ];
  home.packages =(with pkgs; [
    meson
    wayland-protocols
    wayland-utils
    wlroots
    swww
    wl-clipboard
  ]);

  services.playerctld.enable = true;
}
