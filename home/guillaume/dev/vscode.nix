{pkgs, config, ...} : {
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
            nvarner.typst-lsp
            tomoki1207.pdf
            catppuccin.catppuccin-vsc
            llvm-vs-code-extensions.vscode-clangd
            rust-lang.rust-analyzer
            vadimcn.vscode-lldb
            ocamllabs.ocaml-platform
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
                name = "Everforest";
                publisher = "sainnhe";
                version = "0.3.0";
                sha256 = "sha256-nZirzVvM160ZTpBLTimL2X35sIGy5j2LQOok7a2Yc7U=";
            }
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
            ];


        # Shortcuts
        keybindings= [
            {
            key = "ctrl+shift+x";
            command = "workbench.action.terminal.toggleTerminal";
            }
        ];

        userSettings.editor.formatOnSave = true;

        # Theme and iconTheme
        userSettings.workbench.iconTheme = "material-icon-theme";
        userSettings.workbench.colorTheme = "Catppuccin Frappé";

        userSettings.catppuccin.accentColor = "green";

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


    };

}
