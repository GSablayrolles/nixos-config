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
    obsidian
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
}
