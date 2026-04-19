{ config, ... }:
let
  colors = config.lib.stylix.colors;
in
{
  xdg.configFile."wlogout/icons".source = ./icons;
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "logout";
        action = "hyprlock";
        text = "Logout";
        keybind = "e";
      }
    ];
    style = ''
      window {
        font-family: monospace;
        font-size: 14pt;
        color: #${colors.base07}; 
        background: none;
      }

      button {
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        border: none;
        background-color: #${colors.base01};
        margin: 5px;
        transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
      }

      button:hover {
        background-color: #${colors.base01};
      }

      button:focus {
        background-color: #${colors.base0E};
        color: #${colors.base01};
      }

      #lock {
        background-image: image(url("icons/lock.png"));
        color: #${colors.base0B};
      }
      #lock:focus {
        background-color: #${colors.base0B};
        color: #${colors.base01};
      }

      #logout {
        background-image: image(url("icons/logout.png"));
        color: #${colors.base0A};
      }
      #logout:focus {
        background-color: #${colors.base0A};
        color: #${colors.base01};
      }

      #shutdown {
        background-image: image(url("icons/shutdown.png"));
        color: #${colors.base08};
      }
      #shutdown:focus {
        background-color: #${colors.base08};
        color: #${colors.base01};
      }

      #reboot {
        background-image: image(url("icons/reboot.png"));
        color: #${colors.base0D};
      }
      #reboot:focus {
        background-color: #${colors.base0D};
        color: #${colors.base01};
      }

    '';
  };
}

#   base00: "#282828" # ----
#   base01: "#3c3836" # ---
#   base02: "#504945" # --
#   base03: "#665c54" # -
#   base04: "#bdae93" # +
#   base05: "#d5c4a1" # ++
#   base06: "#ebdbb2" # +++
#   base07: "#fbf1c7" # ++++
#   base08: "#fb4934" # red
#   base09: "#fe8019" # orange
#   base0A: "#fabd2f" # yellow
#   base0B: "#b8bb26" # green
#   base0C: "#8ec07c" # aqua/cyan
#   base0D: "#83a598" # blue
#   base0E: "#d3869b" # purple
#   base0F: "#d65d0e" # brown
