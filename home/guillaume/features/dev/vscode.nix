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
          redhat.vscode-yaml

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

      userSettings = {
        update.showReleaseNotes = false;

        # AI remove
        titleBar.openInAgentsWindow.enabled = false;
        chat.titleBar = {
          signIn.enabled = false;
          openInAgentsWindow.enabled = false;
        };

        # Theme and iconTheme
        workbench.iconTheme = "material-icon-theme";

        editor = {
          formatOnSave = true;

          # Indent
          detectIndentation = false;
          indent_style = "space";
          indentSize = 4;
          insertSpaces = true;
          tabSize = 2;

          # Font
          fontLigatures = true;
          fontFamily = config.fontProfiles.monospace.family;
        };

        # Git
        git = {
          autofetch = true;
          confirmSync = false;
        };

        # Nix IDE
        nix-ide.formatterPath = "${pkgs.nixfmt}/bin/nixfmt";
        nix = {
          enableLanguageServer = true;
          serverPath = "${pkgs.nil}/bin/nil";
          formatterPath = "${pkgs.nixfmt}/bin/nixfmt";
          serverSettings.nil.formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
        };
      };
    };
  };

}
