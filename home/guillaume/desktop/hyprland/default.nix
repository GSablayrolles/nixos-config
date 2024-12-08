{
  pkgs,
  ...
}: {
  imports = [
    ./binds.nix
    ./window-bind.nix
    ./decoration.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    xwayland.enable = true;

    extraConfig = let
      swww-script = pkgs.writeShellScript "swww-script" ''
        # have pre-start here itself
        ${pkgs.swww}/bin/swww init &

        # Start Service here
        ${pkgs.swww}/bin/swww clear 000000
      '';
    in ''
      exec-once = ${swww-script}
    '';

    settings = {
      env = [
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

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      misc = {
        mouse_move_enables_dpms = true;
        #enable_swallow = true;
        #swallow_regex = "^(kitty)$";
        vfr = "on";
        focus_on_activate = true;
      };
    };
  };
}
