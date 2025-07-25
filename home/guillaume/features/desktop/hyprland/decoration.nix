{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop.wayland;
in
{
  wayland.windowManager.hyprland.settings = mkIf cfg.hyprland.enable {
    general = {
      gaps_in = 2;
      gaps_out = 4;
      border_size = 2;
      layout = "dwindle";
    };

    decoration = {

      rounding = 6;
      active_opacity = 1.0;
      inactive_opacity = 0.95;
      fullscreen_opacity = 1.0;

      shadow = {
        enabled = false;
      };

      blur = {
        enabled = true;
        size = 5;
        passes = 3;
        new_optimizations = true;
        ignore_opacity = true;
      };
    };

    animations = {
      enabled = true;
      bezier = [
        "easein,0.11, 0, 0.5, 0"
        "easeout,0.5, 1, 0.89, 1"
        "easeinback,0.36, 0, 0.66, -0.56"
        "easeoutback,0.34, 1.56, 0.64, 1"
        "easeinoutback,0.68, -0.6, 0.32, 1.6"
      ];

      animation = [
        "windowsIn,1,3,easeoutback,slide top"
        "windowsOut,1,3,easeinoutback,slide bottom"
        "windowsMove,1,3,easeoutback"
        "workspaces,1,2,easeoutback,slide"
        "fadeIn,1,3,easeout"
        "fadeOut,1,3,easein"
        "fadeSwitch,1,3,easeout"
        "fadeShadow,1,3,easeout"
        "fadeDim,1,3,easeout"
        "border,1,3,easeout"
      ];
    };
  };
}
