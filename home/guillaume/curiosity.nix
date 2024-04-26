{pkgs, ...}: {
  imports = [
    ./home-manager.nix
    ./kitty.nix
    ./gnome.nix
    ./oh-my-zsh.nix
    ./vscode.nix
    ./hyprland
    ./wayland-wm
    ./options
  ];

  home.packages = with pkgs; [
    kitty # terminal
    discord
    pfetch
    neofetch
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


    fontProfiles = {
    enable = true;
    monospace = {
      family = "FiraCode Nerd Font";
      package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };
}
