{ pkgs, ... }:

{
  imports = [
    ./shared
    ./features
  ];

  home.packages = with pkgs; [
    kitty # terminal
    pfetch
    neofetch
    pipes
    obsidian
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  # Browser
  programs.brave = {
    enable = true;
  };

  monitors = [
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      x = 0;
      workspace = "1";
      refreshRate = 75;
    }
    {
      name = "DP-1";
      width = 1920;
      height = 1080;
      x = 1920;
      workspace = "2";
      primary = true;
      refreshRate = 120;
    }
  ];
}
