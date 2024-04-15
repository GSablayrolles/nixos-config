{pkgs, ...}: {
  imports = [
    ./home-manager.nix
    ./gnome.nix
    ./oh-my-zsh.nix
  ];

  home.packages = with pkgs; [
    kitty # terminal
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; [
      mkhl.direnv
      jnoortheen.nix-ide
      redhat.java
      vscjava.vscode-gradle
      vscjava.vscode-java-debug
      oderwat.indent-rainbow
      pkief.material-icon-theme
    ];
  };

  programs.git = {
    enable = true;
    userName = "Guillaume Sablayrolles";
    userEmail = "g.sablayrolles@proton.me";
	extraConfig = {
      credential.helper = "store";
};
  };
}
