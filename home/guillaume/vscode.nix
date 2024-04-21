{pkgs, ...} : {
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
    github.github-vscode-theme
    pkief.material-icon-theme
  ];

  # Theme and iconTheme
  userSettings.workbench.iconTheme = "material-icon-theme";
  userSettings.workbench.colorTheme = "GitHub Dark";

  # Indentation
  userSettings.editor.indentSize = 4;
  userSettings.editor.tabSize = 4;
  };
}