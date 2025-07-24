{ pkgs, ... }:
{

  home.packages = with pkgs; [
    kitty # terminal
    pfetch
    neofetch
    pipes
    obsidian
  ];

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
}
