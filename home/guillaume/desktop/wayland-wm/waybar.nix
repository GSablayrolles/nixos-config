{
  outputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib);

  # Dependencies
  cat = "${pkgs.coreutils}/bin/cat";
  cut = "${pkgs.coreutils}/bin/cut";
  grep = "${pkgs.gnugrep}/bin/grep";
  wc = "${pkgs.coreutils}/bin/wc";
  jq = "${pkgs.jq}/bin/jq";
  rofi = "${pkgs.rofi}/bin/rofi";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
  playerctld = "${pkgs.playerctl}/bin/playerctld";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  btm-kitty = "${pkgs.kitty}/bin/kitty ${pkgs.bottom}/bin/btm";
  nmtui-kitty = "${pkgs.kitty}/bin/kitty ${pkgs.networkmanager}/bin/nmtui";
  #nvtop-kitty = "${pkgs.kitty}/bin/kitty ${pkgs.nvtopPackages.nvidia}/bin/nvtop";

  # Function to simplify making waybar outputs
  jsonOutput = name: {
    pre ? "",
    text ? "",
    tooltip ? "",
    alt ? "",
    class ? "",
    percentage ? "",
  }: "${pkgs.writeShellScriptBin "waybar-${name}" ''
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
in {
  stylix.targets.waybar.enable = false;
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or []) ++ ["-Dexperimental=true"];
    });
    systemd.enable = true;

    style = with config.lib.stylix; ''
      /*Every elements*/
      * {
        font-family: ${config.fontProfiles.regular.family}, ${config.fontProfiles.monospace.family};
        font-size: 10pt;
        padding: 0;
        border: none;
        border-radius: 0;
      }

      /*Every waybar*/
      window#waybar {
        padding: 0;
        /*background: content-box radial-gradient(#${colors.base05}, #${colors.base03});*/
        background: #${colors.base03};
      }

      /*Current music player(left side)*/
      #custom-currentplayer {
        background-color: #${colors.base00};
        color: #${colors.base0D};
        border-radius: 0px 20px 20px 0px;
        padding: 0px 8px 0px 10px;
        margin: 0px;
        margin-right: 3.5px;
        font-size: 18px;
      }

      /*Current hostname (right side)*/
      #custom-hostname {
        background-color: #${colors.base00};
        color: #${colors.base0D};
        border-radius: 20px 0px 0px 20px;
        padding: 0px 8px 0px 8px;
        margin: 0px;
        margin-left: 3.5px;
        font-weight: bold;
      }

      /*Number and icons for workspaces*/
      #workspaces {
        background-color: #${colors.base00};
        color: #${colors.base06};
        margin: 2px;
        padding: 3px 2px;
        border-radius: 16px;
        font-weight: bold;
      }

      /*Button around workspace*/
      #workspaces button {
        background-color: #${colors.base01};
        color: #${colors.base0F};
        padding: 0px 10px;
        margin: 0px 4px;
        border-radius: 16px;
        min-width: 20px;
        transition: all 0.2s ease-in-out;
      }

      /*Current workspace*/
      #workspaces button.active {
        background-color: #${colors.base0D};
        color: #${colors.base08};
        border-radius: 16px;
        min-width: 35px;
        background-size: 400% 400%;
        transition: all 0.2s ease-in-out;
      }

      /*Mooving over a workspace*/
      #workspaces button:hover {
        background-color: #${colors.base04};
        color: #${colors.base0F};
        border-radius: 16px;
        min-width: 35px;
        background-size: 400% 400%;
      }

      /*Pretty explicit*/
      #cpu, #memory, #tray, #pulseaudio, #network, #battery, #clock, #custom-notifications{
        background-color: #${colors.base00};
        color: #${colors.base05};
        margin: 4px 3.5px;
        border-radius: 16px;
        padding: 0px 20px;
        font-weight: bold;
      }

      #battery {
          color: #${colors.base0B};
      }

      #clock {
          margin: 0 3.5px;
          color: #${colors.base06};
          font-size: 12pt;
      }

      #network {
        color: #${colors.base0C};
      }

      tooltip {
          background-color: #${colors.base00};
          border-radius: 10%;
      }

      #custom-power {
        background-color: #${colors.base00};
        color: #${colors.base0D};
        border-radius: 20px 0px 0px 20px;
        padding: 0px 8px 0px 8px;
        margin: 0px;
        margin-left: 3.5px;
        font-weight: bold;
        font-size: 12pt;
      }

      #custom-quit, #custom-lock, #custom-reboot {
          color: #${colors.base0E};
          padding: 0 3px;
          background-color: #${colors.base00};
          font-size: 12pt;
      }

    '';

    settings = {
      primary = {
        layer = "top";
        height = 30;
        margin = "0";
        position = "top";
        exclusive = true;

        # Left bar modules
        modules-left =
          [
            "custom/currentplayer"
            "custom/player"
          ]
          ++ (lib.optionals config.wayland.windowManager.sway.enable [
            "sway/workspaces"
            "sway/mode"
          ])
          ++ (lib.optionals config.wayland.windowManager.hyprland.enable [
            "hyprland/workspaces"
            "hyprland/submap"
          ]);

        # Center bar modules
        modules-center = [
          "cpu"
          "memory"
          "clock"
          "pulseaudio"
          "custom/notifications"
        ];

        # Right bar modules
        modules-right = [
          "network"
          "battery"
          "tray"
          #"custom/hostname"
          "group/group-power"
        ];

        clock = {
          format = "{:%d/%m %H:%M}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };

        cpu = {
          format = "   {usage}%";
          on-click = btm-kitty;
        };

        memory = {
          format = "󰍛  {}%";
          on-click = btm-kitty;
          interval = 5;
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "   0%";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            portable = "";
            default = ["" "" ""];
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

        "hyprland/workspaces" = {
          format-window-separator = " ";
          active-only = false;
          all-outputs = false;
          show-special = true;
          window-rewrite-default = "";
          format = "{name} {windows}";
          "window-rewrite" = {
            "title<.*youtube.*>" = "";
            "brave" = "";
            "class<firefox> title<.*github.*>" = "";
            "warp" = "";
            "kitty" = "";
            "code" = "󰨞";
            "Discord" = "󰙯";
            "class<Spotify>" = "󰓇";
            "matlab" = "󰆧";
            "Super Productivity" = "󰨟";
            "Beeper" = "💬";
            "LM Studio" = "";
          };
        };

        battery = {
          bat = "BAT0";
          interval = 10;
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          onclick = "";
        };

        "sway/window" = {
          max-length = 20;
        };

        network = {
          interval = 3;
          format-wifi = "   {essid}";
          format-ethernet = "󰈁 Connected";
          format-disconnected = "";
          tooltip-format = ''
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
          on-click = nmtui-kitty;
        };

        "custom/hostname" = {
          exec = "echo @$HOSTNAME";
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
            "spotify" = " 󰓇";
            "ncspot" = " 󰓇";
            "qutebrowser" = "󰖟";
            "brave" = " ";
            "discord" = " 󰙯 ";
            "sublimemusic" = " ";
            "kdeconnect" = "󰄡 ";
          };
          on-click = "${playerctld} shift";
          on-click-right = "${playerctld} unshift";
        };
        "custom/player" = {
          exec-if = "${playerctl} status";
          exec = ''${playerctl} metadata --format '{"text": "{{artist}} - {{title}}", "alt": "{{status}}", "tooltip": "{{title}} ({{artist}} - {{album}})"}' '';
          return-type = "json";
          interval = 2;
          max-length = 30;
          format = "{icon} {}";
          format-icons = {
            "Playing" = "󰐊";
            "Paused" = "󰏤 ";
            "Stopped" = "󰓛";
          };
          on-click = "${playerctl} play-pause";
        };

        "group/group-power" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = true;
          };
          modules = [
            "custom/power"
            "custom/quit"
            "custom/lock"
            "custom/reboot"
          ];
        };

        "custom/quit" = {
          format = "󰗼";
          on-click = "${pkgs.hyprland}/bin/hyprctl dispatch exit";
          tooltip = false;
        };

        "custom/lock" = {
          format = "󰍁";
          on-click = "${lib.getExe pkgs.hyprlock}";
          tooltip = false;
        };

        "custom/reboot" = {
          format = "󰜉";
          on-click = "${pkgs.systemd}/bin/systemctl reboot";
          tooltip = false;
        };

        "custom/power" = {
          format = "";
          on-click = "${pkgs.systemd}/bin/systemctl poweroff";
          tooltip = false;
        };
      };
    };
  };
}
