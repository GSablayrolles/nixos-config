{
  config,
  pkgs,
  ...
}:
let
  cliphist-rofi-img = ".config/rofi/cliphist-rofi-img";
in
{
  home.file.${cliphist-rofi-img} = {
    text = ''
        #!/usr/bin/env bash

      tmp_dir="/tmp/cliphist"
      rm -rf "$tmp_dir"

      if [[ -n "$1" ]]; then
          cliphist decode <<<"$1" | wl-copy
          exit
      fi

      mkdir -p "$tmp_dir"

      read -r -d \'\' prog <<EOF
      /^[0-9]+\s<meta http-equiv=/ { next }
      match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
          system("echo " grp[1] "\\\\\t | cliphist decode >$tmp_dir/"grp[1]"."grp[3])
          print \$0"\0icon\x1f$tmp_dir/"grp[1]"."grp[3]
          next
      }
      1
      EOF
      cliphist list | gawk "$prog"
    '';
    executable = true;
  };
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    terminal = config.home.sessionVariables.TERMINAL;
    extraConfig = {
      modi = "drun,filebrowser,window,run";
      show-icons = true;
      display-drun = " ";
      display-run = " ";
      display-filebrowser = " ";
      display-window = " ";
      drun-display-format = "{name}";
      dpi = 1;
    };

    theme =
      let
        # Use `mkLiteral` for string-like values that should show without
        # quotes, e.g.:
        # {
        #   foo = "abc"; =&gt; foo: "abc";
        #   bar = mkLiteral "abc"; =&gt; bar: abc;
        # };
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          margin = 0;
          padding = 0;
          spacing = 0;
        };

        "window" = {
          width = mkLiteral "50%";
          height = mkLiteral "50%";
          x-offset = mkLiteral "0px";
          y-offset = mkLiteral "0px";
          padding = mkLiteral "0em";

          border = mkLiteral "2px";
          border-radius = mkLiteral "6px";
        };

        "mainbox" = {
          enabled = mkLiteral "true";
          spacing = mkLiteral "0em";
          padding = mkLiteral "0em";
          orientation = mkLiteral "vertical";
          children = mkLiteral ''[ "inputbar" , "listbox" , "mode-switcher" ]'';
          background-color = mkLiteral "transparent";
        };

        # // Inputs //
        "inputbar" = {
          enabled = mkLiteral "true";
          children = mkLiteral ''[ "entry" ]'';
        };

        "entry" = {
          enabled = mkLiteral "false";
        };

        # // Lists //
        "listbox" = {
          padding = mkLiteral "0em";
          spacing = mkLiteral "0em";
          orientation = mkLiteral "horizontal";
          children = mkLiteral ''[ "listview" ]'';
          #background-color = mkLiteral "transparent";
          background-image = mkLiteral ''url("hosts/curiosity/red_mountains.png", width)'';
        };

        "listview" = {
          padding = mkLiteral "2em";
          spacing = mkLiteral "1em";
          enabled = mkLiteral "true";
          columns = mkLiteral "5";
          cycle = mkLiteral "true";
          dynamic = mkLiteral "true";
          scrollbar = mkLiteral "false";
          layout = mkLiteral "vertical";
          reverse = mkLiteral "false";
          fixed-height = mkLiteral "true";
          fixed-columns = mkLiteral "true";
          cursor = mkLiteral "default";
        };

        # // Modes //
        "mode-switcher" = {
          orientation = mkLiteral "horizontal";
          enabled = mkLiteral "true";
          padding = mkLiteral "2em 9.8em 2em 9.8em";
          spacing = mkLiteral "2em";
          #background-color = mkLiteral "transparent";
        };

        "button" = {
          cursor = mkLiteral "pointer";
          padding = mkLiteral "2.5em";
          spacing = mkLiteral "0em";
          border-radius = mkLiteral "3em";
        };

        # "button selected" {
        #     background-color:            @main-fg;
        #     text-color:                  @main-bg;
        # }

        # // Elements //
        "element" = {
          orientation = mkLiteral "vertical";
          enabled = mkLiteral "true";
          spacing = mkLiteral "0.2em";
          padding = mkLiteral "0.5em";
          cursor = mkLiteral "pointer";
          #background-color = mkLiteral "transparent";
        };

        # "element selected.normal" {
        #     background-color:        @select-bg;
        #     text-color:                  @select-fg;
        # }

        "element-icon" = {
          size = mkLiteral "5.5em";
          cursor = mkLiteral "inherit";
          #background-color = mkLiteral "transparent";
          # text-color:                  inherit;
        };

        "element-text" = {
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.5";
          cursor = mkLiteral "inherit";
          #background-color = mkLiteral "transparent";
          #text-color:inherit;
        };

        # // Error message //
        "error-message" = {
          # text-color:                  @main-fg;
          # background-color:            @main-bg;
          text-transform = mkLiteral "capitalize";
          children = mkLiteral ''[ "textbox" ]'';
        };

        "textbox" = {
          # text-color = mkLiteral "inherit";
          # background-color = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.5";
        };
      };
  };
}
