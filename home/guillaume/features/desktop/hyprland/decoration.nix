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
      shadow = {
        enabled = false;
      };
      rounding = 6;
    };
  };
}
