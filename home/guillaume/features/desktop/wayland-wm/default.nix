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
    ./swaync
    ./waybars
    ./rofi
  ];
  home.packages = mkIf cfg.wayland.enable (
    with pkgs;
    [
      meson
      wayland-protocols
      wayland-utils
      wlroots
      awww
      wl-clipboard
      swaynotificationcenter
    ]
  );

  services.playerctld.enable = cfg.wayland.enable;
  services.cliphist.enable = cfg.wayland.enable;

}
