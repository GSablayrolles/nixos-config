{ pkgs, ... }:
{
  imports = [
    ./desktop
    ./home-manager.nix
    ./dev
    ./terminal
    ./options
  ];

  home.packages = with pkgs; [
    kitty # terminal
    discord
    pfetch
    neofetch
    pipes
  ];

  programs.git = {
    enable = true;
    userName = "Guillaume Sablayrolles";
    userEmail = "g.sablayrolles@proton.me";
    extraConfig = {
      credential.helper = "store";
    };
  };

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
