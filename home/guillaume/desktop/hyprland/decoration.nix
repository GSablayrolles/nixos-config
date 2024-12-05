{
  config,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_out = 5;
      # "col.active_border" = "0xff${palette.base0C}";
      border_size = 2;
    };

    decoration = {
      rounding = 6;

      shadow = {
        enabled = true;
        range = 12;
        offset = "3 3";
      };
    };
  };
}
