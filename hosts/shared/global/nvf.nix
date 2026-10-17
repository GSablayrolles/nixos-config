{
  pkgs,
  ...
}:

{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        statusline.lualine.enable = true;
        autocomplete.nvim-cmp.enable = true;
        telescope.enable = true;

        extraPackages = with pkgs; [
          ripgrep
          fd
          tree-sitter
        ];

        options = {
          tabstop = 2;
          shiftwidth = 2;
        };

        formatter.conform-nvim.presets.nixfmt.enable = true;

        lsp = {
          enable = true;
          formatOnSave = true;
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;

          nix = {
            enable = true;
            format = {
              type = [ "nixfmt" ];
            };
            lsp = {
              enable = true;
              servers = [ "nil" ];
            };
          };

          typescript.enable = true;
          markdown.enable = true;
          rust.enable = true;
        };
      };
    };
  };
}
