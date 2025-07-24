{
  config,
  lib,
  ...
}:
let
in
{
  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 4000;
      scrollback_pager_history_size = 2048;
      theme = "Solarized Light";
      window_padding_width = 15;
    };
  };
}
