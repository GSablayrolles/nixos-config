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
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or []) ++ ["-Dexperimental=true"];
    });
    systemd.enable = true;

    style = let 
    inherit (config.colorscheme) palette;
    greenGruv = "83C092";
    in ''
        * {
          font-family: ${config.fontProfiles.regular.family}, ${config.fontProfiles.monospace.family};
          font-size: 10pt;
          padding: 0 8px;
          color: #${palette.base0F};
        }

        window#waybar.top {
          padding: 0;
          background-color: transparent;
          border: 2px solid #${palette.base08};
          border-radius: 10px;
        }

        .modules-center {
            background-color: #${palette.base09};
            border-radius: 10px;
        }

        .modules-right {
            padding: 0;
        }

        #network {
            color: #${palette.base05};
        }

        #battery {
            color: #${palette.base0D};
        }

        #clock, #custom-hostname {
            background-color: #${palette.base08};
            border-radius: 10px;
        }

    '';

    settings = {
      primary = {
        layer = "top";
        height = 30;
        margin = "2";
        position = "top";
        exclusive = false;

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
          "custom/hostname"
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
            "spotify" = " 󰓇";
            "ncspot" = " 󰓇";
            "qutebrowser" = "󰖟";
            "firefox" = " ";
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
      };
    };
  };
}