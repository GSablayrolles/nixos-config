{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;

    plugins = [
      {
        name = "zsh-command-time";
        src =
          pkgs.fetchFromGitHub
          {
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
      plugins = ["git" "history" "vscode"];
      theme = "candy";
    };
  };
}

