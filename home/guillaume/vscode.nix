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
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
                name = "Everforest";
                publisher = "sainnhe";
                version = "0.3.0";
                sha256 = "nZirzVvM160ZTpBLTimL2X35sIGy5j2LQOok7a2Yc7U=";
            }
            {
                name = "vscode-color";
                publisher = "anseki";
                version = "0.4.5";
                sha256 = "xclKrAqa/00xmlfqgIi0cPNyzDI6HFc+bz2kpm4d1AY=";
            }
            ];


        # Shortcuts
        keybindings= [
            {
            key = "ctrl+shift+x";
            command = "workbench.action.terminal.toggleTerminal";
            }
        ];

        # Theme and iconTheme
        userSettings.workbench.iconTheme = "material-icon-theme";
        userSettings.workbench.colorTheme = "Everforest Dark";

        # Indent
        userSettings.editor.detectIndentation = false;
        userSettings.editor.indent_style = "space";
        userSettings.editor.indentSize = 4;
        userSettings.editor.insertSpaces = true;
        userSettings.editor.tabSize = 2;

        # Everforest
        userSettings.everforest.darkWorkbench = "high-contrast";

         # Font
        userSettings.editor.fontLigatures = true;
        userSettings.editor.fontFamily = config.fontProfiles.monospace.family;

    };

}