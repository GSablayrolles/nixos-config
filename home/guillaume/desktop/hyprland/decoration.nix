{
  config,
  lib,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
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
