{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop.wayland;
in
{
  imports = [
    ./binds.nix
    ./window-bind.nix
    ./decoration.nix
    ./hyprlock
    ./wlogout
  ];

  wayland.windowManager.hyprland = mkIf cfg.hyprland.enable {
    enable = true;

    configType = "hyprlang";
    xwayland.enable = true;

    extraConfig =
      let
        swaync = lib.getExe' pkgs.swaynotificationcenter "swaync";
        hypridle = lib.getExe pkgs.hypridle;
      in
      ''
        exec-once = ${swaync}
        exec-once = ${hypridle}
      '';

    settings = {
      env = [
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "WLR_NO_HARDWARE_CURSORS,1"
        "NIXOS_OZONE_WL,1"
      ];

      input = {
        kb_layout = "fr,us";
        touchpad = {
          disable_while_typing = false;
          natural_scroll = true;
        };
      };

      gesture = [
        "3, horizontal, workspace"
      ];

      misc = {
        mouse_move_enables_dpms = true;
        focus_on_activate = true;
      };
    };
  };
}
