{lib, config, pkgs, inputs, ...}: {
    imports = [
        ./binds.nix
        ./window-bind.nix
    ];

    wayland.windowManager.hyprland = {
        enable = true;

        package = inputs.hyprland.packages."${pkgs.system}".hyprland;

        xwayland.enable = true;

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
                enable_swallow = true;
                swallow_regex = "^(kitty)$";
                vfr = "on";
                focus_on_activate = true;
            };
        };
    };
}