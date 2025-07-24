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
      gaps_out = 5;
      # "col.active_border" = "0xff${palette.base0C}";
      border_size = 2;
    };

    decoration = {
      shadow = {
        enabled = false;
      };
      rounding = 6;
    };
  };
}
