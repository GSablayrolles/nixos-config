{pkgs, ...}: {
  imports = [
    ./home-manager.nix
    ./gnome.nix
    ./oh-my-zsh.nix
    ./vscode.nix
    ./hyprland.nix
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

  programs.kitty = {
    enable = true;
    theme = "Everforest Dark Medium";
  };

}
