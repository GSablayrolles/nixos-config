{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.dev;
in
{
  programs.vscode = mkIf cfg.vscode.enable {
    enable = true;
    package = pkgs.vscode-fhs;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions =
        with pkgs.vscode-extensions;
        [
          mkhl.direnv
          jnoortheen.nix-ide
          redhat.java
          vscjava.vscode-gradle
          vscjava.vscode-java-debug
          oderwat.indent-rainbow
          github.github-vscode-theme
          pkief.material-icon-theme
          tomoki1207.pdf
          llvm-vs-code-extensions.vscode-clangd
          rust-lang.rust-analyzer
          vadimcn.vscode-lldb
          ocamllabs.ocaml-platform
          myriad-dreamin.tinymist
          denoland.vscode-deno
          prisma.prisma
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "vscode-color";
            publisher = "anseki";
            version = "0.4.5";
            sha256 = "xclKrAqa/00xmlfqgIi0cPNyzDI6HFc+bz2kpm4d1AY=";
          }
          {
            name = "language-matlab";
            publisher = "mathworks";
            version = "1.2.2";
            sha256 = "KR4BtLupplhTBPIvdg4cj0lbkTJROQ6tavOP4wdu8rA=";
          }
          {
            name = "vscode-spring-boot";
            publisher = "vmware";
            version = "1.61.1";
            sha256 = "sha256-xhAX6HUxyuwWr+wzUDrMZ4fdsOuf2b08/d8LvavPQqE=";
          }

        ];

      # Shortcuts
      keybindings = [
        {
          key = "ctrl+shift+x";
          command = "workbench.action.terminal.toggleTerminal";
        }
      ];

      userSettings.editor.formatOnSave = true;

      # Theme and iconTheme
      userSettings.workbench.iconTheme = "material-icon-theme";

      # Indent
      userSettings.editor.detectIndentation = false;
      userSettings.editor.indent_style = "space";
      userSettings.editor.indentSize = 4;
      userSettings.editor.insertSpaces = true;
      userSettings.editor.tabSize = 2;

      #Everforest
      #userSettings.everforest.darkWorkbench = "high-contrast";

      # Font
      userSettings.editor.fontLigatures = true;
      userSettings.editor.fontFamily = config.fontProfiles.monospace.family;

      # Git
      userSettings.git.autofetch = true;
      userSettings.git.confirmSync = false;

      # Nix IDE
      userSettings.nix-ide.formatterPath = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      userSettings.nix.enableLanguageServer = true;
      userSettings.nix.serverPath = "${pkgs.nil}/bin/nil";
      userSettings.nix.formatterPath = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      userSettings.nix.serverSettings.nil.formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
    };
  };

}
