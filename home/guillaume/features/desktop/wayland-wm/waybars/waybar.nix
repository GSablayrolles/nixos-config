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
        exclusive = false;
        fixed-center = false;
        modules-left =
          lib.optionals config.wayland.windowManager.hyprland.enable [
            "hyprland/workspaces"
            #"hyprland/submap"
          ]
          ++ [
            "cpu"
            "memory"
          ];
        modules-center = [
          "custom/player"
          #"custom/gpu"
        ];
        modules-right = [
          "tray"
          #"custom/hostname"
          "network"
          "battery"
          "custom/hypridle"
          "custom/currentplayer"
          "pulseaudio"
          "custom/notifications"
          "clock"
        ];

        clock = {
          format = "{:%d/%m %H:%M}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
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
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " 0%";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            portable = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = pavucontrol;
        };

        "custom/notifications" = {
          tooltip = false;
          format = "{} {icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which ${swaync-client}";
          exec = "${swaync-client} -swb";
          on-click = "${swaync-client} -t -sw";
          on-click-right = "${swaync-client} -d -sw";
          escape = true;
        };

        "custom/hypridle" =
          let
            pgrep = "${pkgs.toybox}/bin/pgrep";
            pkill = "${pkgs.toybox}/bin/pkill";
            hypridle = "${pkgs.hypridle}/bin/hypridle";
          in
          {
            interval = 2;
            # format = "";
            exec = ''
              if ${pgrep} "hypridle" > /dev/null
                then
                    echo " "
                else
                    echo " "
                fi

            '';
            tooltip = false;

            on-click =
              let
                noti = "${pkgs.noti}/bin/noti";
              in
              ''
                if ${pgrep} "hypridle" > /dev/null
                then
                    ${pkill} hypridle
                    ${noti} -t "   Hypridle Inactive"
                else
                    ${hypridle} &
                    ${noti} -t "   Hypridle Active"
                fi
              '';
          };

        "hyprland/workspaces" = {
          format-window-separator = "";
          active-only = false;
          all-outputs = false;
          show-special = true;
          window-rewrite-default = "";
          format = "{name}{windows}";
          "window-rewrite" = {
            "title<.*youtube.*>" = " ";
            "class<firefox>" = " ";
            "class<firefox> title<.*github.*>" = " ";
            "warp" = " ";
            "kitty" = " ";
            "codium-url-handler" = " 󰨞";
            "Discord" = " 󰙯";
            "spotube" = " 󰓇";
            "matlab" = "󰆧";
            "Super Productivity" = " 󰨟";
            "Beeper" = " 💬";
            "LM Studio" = " ";
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
          onclick = "";
        };
        "sway/window" = {
          max-length = 20;
        };
        network = {
          interval = 3;
          format-wifi = "  {essid}";
          format-ethernet = "󰈁";
          format-disconnected = "";
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

        "custom/currentplayer" = {
          interval = 2;
          return-type = "json";
          exec = jsonOutput "currentplayer" {
            pre = ''
              player="$(${playerctl} status -f "{{playerName}}" 2>/dev/null || echo "No player active" | ${cut} -d '.' -f1)"
              count="$(${playerctl} -l | ${wc} -l)"
              if ((count > 1)); then
                more=" +$((count - 1))"
              else
                more=""
              fi
            '';
            alt = "$player";
            tooltip = "$player ($count available)";
            text = "$more";
          };
          format = "{icon}{}";
          format-icons = {
            "No player active" = " ";
            "Celluloid" = "󰎁 ";
            "spotube" = "󰓇";
            "ncspot" = "󰓇";
            "qutebrowser" = "󰖟";
            "firefox" = " ";
            "discord" = "󰙯 ";
            "sublimemusic" = " ";
            "kdeconnect" = "󰄡 ";
          };
          on-click = "${playerctld} shift";
          on-click-right = "${playerctld} unshift";
        };
        "custom/player" = {
          exec-if = "${playerctl} status";
          exec = ''
            ${playerctl} metadata --format '{"text": "{{artist}} - {{title}}", "alt": "{{status}}", "tooltip": "{{title}} ({{artist}} - {{album}})"}' | sed 's/\&/&amp;/g'
          '';
          return-type = "json";
          interval = 2;
          #max-length = 30;
          format = "{icon} {}";
          format-icons = {
            "Playing" = "󰐊";
            "Paused" = "󰏤 ";
            "Stopped" = "󰓛";
          };
          on-click = "${playerctl} play-pause";
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
            font-size: 8pt;
        }

        window#waybar {
            background-color: transparent;
        }


        #workspaces button.focused,
        #workspaces button.active,

        #clock,
        #cpu,
        #memory,
        #custom-notifications,
        #custom-hostname,
        #battery,
        #custom-hypridle,
        #network,
        #pulseaudio,
        #tray,
        #custom-currentplayer,
        #custom-player
        {
            background-color:  #${colors.base01}; /* 01 */
            color: #${colors.base0D}; /* 05 */
            padding: 0px 8px;
            border-radius: 10px;
            margin: 3px;
            border: 1px solid #${colors.base0D};
        }


        #workspaces button {
            border-radius: 5;
            padding: 0 8px
        }

        #workspaces button,
        #workspaces button.hidden
        {
            background-color: #${colors.base01}; /* 0A */
            color: #${colors.base0D}; /* 00 */
            padding: 0px 8px;
            border-radius: 10px;
            margin: 3px;
            border: 1px solid #${colors.base0D};
        }
      '';
  };
}
