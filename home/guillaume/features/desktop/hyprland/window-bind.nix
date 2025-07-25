{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop.wayland;

  workspaces = (map toString (lib.range 0 9)) ++ (map (n: "F${toString n}") (lib.range 1 12));
  # Map keys to hyprland directions
  directions = rec {
    left = "l";
    right = "r";
    up = "u";
    down = "d";
    h = left;
    l = right;
    k = up;
    j = down;
  };

  # Map numbers to azerty characters
  azerty = {
    "1" = "ampersand";
    "2" = "eacute";
    "3" = "quotedbl";
    "4" = "apostrophe";
    "5" = "parenleft";
    "6" = "minus";
    "7" = "egrave";
    "8" = "underscore";
    "9" = "ccedilla";
    "0" = "agrave";
  };

  toAzerty = n: if (builtins.elem n (lib.attrNames azerty)) then azerty.${n} else n;
in
{
  wayland.windowManager.hyprland.settings = mkIf cfg.hyprland.enable {
    bindm = [
      "SUPER,mouse:272,movewindow"
      "SUPER,mouse:273,resizewindow"
    ];

    bind = [
      "SUPERSHIFT,q,killactive"
      "SUPERSHIFT,e,exit"

      "SUPER,s,togglesplit"
      "SUPER,f,fullscreen,1"
      "SUPERSHIFT,f,fullscreen,0"
      "SUPERSHIFT,space,togglefloating"

      "SUPER,KP_Subtract,splitratio,-0.25"
      "SUPERSHIFT,KP_Subtract,splitratio,-0.3333333"

      "SUPER,KP_Add,splitratio,0.25"
      "SUPERSHIFT,KP_Add,splitratio,0.3333333"

      "SUPER,g,togglegroup"
      "SUPER,b,changegroupactive,f"
      "SUPERSHIFT,r,changegroupactive,r"

      "SUPER,u,togglespecialworkspace, U"
      "SUPERSHIFT,u,movetoworkspace,special:U"

      "SUPER,i,togglespecialworkspace, I"
      "SUPERSHIFT,i,movetoworkspace,special:I"
    ]
    ++
      # Change workspace
      (map (n: "SUPER,${toAzerty n},workspace,name:${n}") workspaces)
    ++
      # Move window to workspace
      (map (n: "SUPERSHIFT,${toAzerty n},movetoworkspacesilent,name:${n}") workspaces)
    ++
      # Move focus
      (lib.mapAttrsToList (key: direction: "SUPER,${key},movefocus,${direction}") directions)
    ++
      # Swap windows
      (lib.mapAttrsToList (key: direction: "SUPERSHIFT,${key},swapwindow,${direction}") directions)
    ++
      # Move monitor focus
      (lib.mapAttrsToList (key: direction: "SUPERCONTROL,${key},focusmonitor,${direction}") directions)
    ++
      # Move window to other monitor
      (lib.mapAttrsToList (
        key: direction: "SUPERCONTROLSHIFT,${key},movewindow,mon:${direction}"
      ) directions)
    ++
      # Move workspace to other monitor
      (lib.mapAttrsToList (
        key: direction: "SUPERALT,${key},movecurrentworkspacetomonitor,${direction}"
      ) directions);
  };
}
