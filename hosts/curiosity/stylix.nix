{
  pkgs,
  lib,
  config,
  ...
}: {
  stylix = {
    enable = true;
    image = ./red_mountains.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    cursor = {
      package = pkgs.numix-cursor-theme;
      name = "Numix-Cursor-Light";
      size = 22;
    };
    fonts = {
      monospace = {
        name = "FiraCode Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
  };
}
