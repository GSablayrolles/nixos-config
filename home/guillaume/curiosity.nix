{ ... }:
{
  imports = [
    ./shared
    ./features
  ];

  home-config = {
    apps = {
      brave.enable = true;
    };

    cli = {
      yazi.enable = true;
      tools.enable = true;
    };

    desktop.wayland = {
      hyprland = {
        enable = true;
        nvidia = true;
      };
      enable = true;
    };

    dev.vscode.enable = true;
  };

}
