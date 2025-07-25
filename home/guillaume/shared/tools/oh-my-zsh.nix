{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    shellAliases =
      let
        eza = lib.getExe pkgs.eza;
        bat = lib.getExe pkgs.bat;
        broot = lib.getExe pkgs.broot;
      in
      {
        ls = "${eza} --long --header --binary --no-permissions --no-user --icons=auto";
        lss = "ls --total-size";
        lst = "ls --tree";
        lsg = "ls --git";

        cat = bat;

        tree = broot;
      };

    plugins = [
      {
        name = "zsh-command-time";
        src = pkgs.fetchFromGitHub {
          owner = "popstas";
          repo = "zsh-command-time";
          rev = "803d26eef526bff1494d1a584e46a6e08d25d918";
          sha256 = "ndHVFcz+XmUW0zwFq7pBXygdRKyPLjDZNmTelhd5bv8=";
        };
        file = "command-time.plugin.zsh";
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "history"
        "vscode"
        "copyfile"
        "copypath"
      ];
      theme = "candy";
    };
  };
}
