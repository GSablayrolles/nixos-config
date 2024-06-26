{
  config,
  pkgs,
  nix-colors,
  ...
}: {

    imports = [
        nix-colors.homeManagerModules.default
    ];

  colorScheme = nix-colors.colorSchemes.catppuccin-frappe;

  home = {
    username = "guillaume";
    homeDirectory = "/home/guillaume";
  };

# org.gnome.desktop.interface gtk
  gtk = {
    enable = true;

    theme = {
      name = "marwaita-pop_os";
      package = pkgs.marwaita-pop_os;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.sessionVariables.GTK_THEME = "marwaita-pop_os";
  home.sessionVariables.TERMINAL = "kitty";
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
