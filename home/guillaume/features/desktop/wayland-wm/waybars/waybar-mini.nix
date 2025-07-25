{
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
  # Dependencies
  cut = "${pkgs.coreutils}/bin/cut";
  wc = "${pkgs.coreutils}/bin/wc";
  jq = "${pkgs.jq}/bin/jq";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
  playerctld = "${pkgs.playerctl}/bin/playerctld";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  btm-kitty = "${pkgs.kitty}/bin/kitty ${pkgs.bottom}/bin/btm";
  nmtui-kitty = "${pkgs.kitty}/bin/kitty ${pkgs.networkmanager}/bin/nmtui";
  nvtop-kitty = "${pkgs.kitty}/bin/kitty ${pkgs.nvtopPackages.nvidia}/bin/nvtop";

  # Function to simplify making waybar outputs
  jsonOutput =
    name:
    {
      pre ? "",
      text ? "",
      tooltip ? "",
      alt ? "",
      class ? "",
      percentage ? "",
    }:
    "${pkgs.writeShellScriptBin "waybar-${name}" ''
      set -euo pipefail
      ${pre}
      ${jq} -cn \
        --arg text "${text}" \
        --arg tooltip "${tooltip}" \
        --arg alt "${alt}" \
        --arg class "${class}" \
        --arg percentage "${percentage}" \
        '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
    ''}/bin/waybar-${name}";
in
{
  stylix.targets.waybar.enable = false;

  programs.waybar = mkIf cfg.wayland.enable {
    enable = true;
    systemd.enable = true;
    settings = {
      primary = {
        layer = "top";
        position = "bottom";
        exclusive = true;
        fixed-center = true;
        modules-center = lib.optionals config.wayland.windowManager.hyprland.enable [
          "hyprland/workspaces"
        ];

        modules-left = [
          "custom/notifications"
          "clock"
          "tray"
          #"custom/gpu"
        ];
        modules-right = [
          "group/expand"
          "bluetooth"
          "network"
          "battery"
        ];

        clock = {
          format = "{:%d/%m %H:%M}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          actions = {
            on-click-right = "shift_down";
            on-click = "shift_up";
          };
        };

        bluetooth = {
          format-on = "󰂯";
          format-off = "BT-off";
          format-disabled = "󰂲";
          format-connected-battery = "{device_battery_percentage}% 󰂯";
          format-alt = "{device_alias} 󰂯";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\n{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\n{device_address}\n{device_battery_percentage}%";
          on-click-right = "blueman-manager";
        };

        "custom/expand" = {
          format = "";
          tooltip = false;
        };

        "custom/endpoint" = {
          format = "|";
          tooltip = false;
        };

        "group/expand" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 600;
            transition-to-left = true;
            click-ot-reveal = true;
          };
          modules = [
            "custom/expand"
            # "cutom/colorpicker"
            "cpu"
            "memory"
            "temperature"
            "custom/endpoint"
          ];
        };

        # "custom/colorpicker" = {
        #   format = "{}";
        #   return-type = "json";
        #   interval = "once";

        # };

        cpu = {
          format = " {usage}%";
          on-click = btm-kitty;
        };

        "custom/gpu" = {
          interval = 5;
          return-type = "json";
          exec = jsonOutput "gpu" {
            text = "";

            tooltip = "";
          };
          on-click = "${nvtop-kitty}";
          format = "{} %";
        };

        memory = {
          format = "󰍛 {}%";
          on-click = btm-kitty;
          interval = 5;
        };

        temperature = {
          critical-threshold = 80;
          format = "";
        };

        # pulseaudio = {
        #   format = "{icon} {volume}%";
        #   format-muted = " 0%";
        #   format-icons = {
        #     headphone = "󰋋";
        #     headset = "󰋎";
        #     portable = "";
        #     default = [
        #       ""
        #       ""
        #       ""
        #     ];
        #   };
        #   on-click = pavucontrol;
        # };

        "custom/notifications" = {
          tooltip = false;
          format = "";
          on-click = "${swaync-client} -t -sw";
          on-click-right = "${swaync-client} -d -sw";
          escape = true;
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
            empty = "";
          };
          persistent-workspaces = {
            "*" = [
              1
              2
              3
              4
              5
            ];
          };
        };

        battery = {
          bat = cfg.wayland.waybarConfig.batteryName;
          interval = 10;
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰂄  {capacity}%";
          format-alt = "{time} {icon}";
          onclick = "";
        };

        network = {
          interval = 3;
          format-wifi = "  {essid}";
          format-ethernet = "󰈁";
          format-disconnected = "";
          tooltip-format = ''
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
          on-click = nmtui-kitty;
        };

        "custom/hostname" = {
          exec = "echo $USER@$HOSTNAME";
        };

      };
    };
    # Cheatsheet:
    # x -> all sides
    # x y -> vertical, horizontal
    # x y z -> top, horizontal, bottom
    # w x y z -> top, right, bottom, left

    style =
      with config.lib.stylix;
      # css
      ''

        * {
            font-size:15px;
            font-family: "CodeNewRoman Nerd Font Propo";
        }
        window#waybar{
            all:unset;
        }
        .modules-left {
            padding:7px;
            margin:10 0 5 10;
            border-radius:10px;
            background: alpha(#${colors.base00},.6);
            box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
        }

        .modules-center {
            padding:7px;
            margin:10 0 5 0;
            border-radius:10px;
            background: alpha(#${colors.base00},.6);
            box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
        }

        .modules-right {
            padding:7px;
            margin: 10 10 5 0;
            border-radius:10px;
            background: alpha(#${colors.base00},.6);
            box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
        }
        tooltip {
            background:#${colors.base00};
            color: #${colors.base07};
        }
        #clock:hover, #custom-pacman:hover, #custom-notification:hover,#bluetooth:hover,#network:hover,#battery:hover, #cpu:hover,#memory:hover,#temperature:hover{
            transition: all .3s ease;
            color:#${colors.base0B};
        }
        #custom-notification {
            padding: 0px 5px;
            transition: all .3s ease;
            color:#${colors.base07};
        }
        #clock{
            padding: 0px 5px;
            color:#${colors.base07};
            transition: all .3s ease;
        }
        #custom-pacman{
            padding: 0px 5px;
            transition: all .3s ease;
            color:#${colors.base07};

        }
        #workspaces {
            padding: 0px 5px;
        }
        #workspaces button {
            all:unset;
            padding: 0px 5px;
            color: alpha(#${colors.base0B},.4);
            transition: all .2s ease;
        }
        #workspaces button:hover {
            color:rgba(0,0,0,0);
            border: none;
            text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .5);
            transition: all 1s ease;
        }
        #workspaces button.active {
            color: #${colors.base0B};
            border: none;
            text-shadow: 0px 0px 2px rgba(0, 0, 0, .5);
        }
        #workspaces button.empty {
            color: rgba(0,0,0,0);
            border: none;
            text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .2);
        }
        #workspaces button.empty:hover {
            color: rgba(0,0,0,0);
            border: none;
            text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .5);
            transition: all 1s ease;
        }
        #workspaces button.empty.active {
            color: #4D726B;
            border: none;
            text-shadow: 0px 0px 2px rgba(0, 0, 0, .5);
        }
        #bluetooth{
            padding: 0px 5px;
            transition: all .3s ease;
            color:#${colors.base07};

        }
        #network{
            padding: 0px 5px;
            transition: all .3s ease;
            color:#${colors.base07};

        }
        #battery{
            padding: 0px 5px;
            transition: all .3s ease;
            color: #b4c8be;


        }
        #battery.charging {
            color: #26A65B;
        }

        #battery.warning:not(.charging) {
            color: #ffbe61;
        }

        #battery.critical:not(.charging) {
            color: #f53c3c;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }
        #group-expand{
            padding: 0px 5px;
            transition: all .3s ease; 
        }
        #custom-expand{
            padding: 0px 5px;
            color:alpha(#${colors.base05},.2);
            text-shadow: 0px 0px 2px rgba(0, 0, 0, .7);
            transition: all .3s ease; 
        }
        #custom-expand:hover{
            color:rgba(255,255,255,.2);
            text-shadow: 0px 0px 2px rgba(255, 255, 255, .5);
        }
        #custom-colorpicker{
            padding: 0px 5px;
        }
        #cpu,#memory,#temperature{
            padding: 0px 5px;
            transition: all .3s ease; 
            color:#${colors.base07};

        }
        #custom-endpoint{
            color:transparent;
            text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 1);

        }
        #tray{
            padding: 0px 5px;
            transition: all .3s ease; 

        }
        #tray menu * {
            padding: 0px 5px;
            transition: all .3s ease; 
        }

        #tray menu separator {
            padding: 0px 5px;
            transition: all .3s ease; 
        }
      '';
  };
}
