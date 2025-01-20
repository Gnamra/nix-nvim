{pkgs, ...}:{
  # Import all your configuration modules here
  imports = [ 
    ./plugins/dap.nix
    ./plugins/lsp-cmp.nix
    ./plugins/lsp.nix
      
  ];
  globals.mapleader = " ";
    globals.clipboard = {
      copy = {
        "+" = ["clip.exe"];
        "*" = ["clip.exe"];
      };
      paste = {
        "+" = ["powershell.exe" "-c" "[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace(\"\\r\", \"\"))"];
        "*" = ["powershell.exe" "-c" "[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace(\"\\r\", \"\"))"];
      };
      cache_enabled = 0;
    };
    clipboard.register = "unnamedplus";

    colorschemes = {
      tokyonight = {
        enable = true;
	settings = {
          style = "night";
	};
      };
    };

    opts = {
      number = true;
      relativenumber = true;
      showmode = false;
      expandtab = true;
      shiftwidth = 2;
      guifont="Fira Code";
    };

    keymaps = [
      {
        key = "<SPACE>";
        action = "<NOP>";
      }
    ];

    plugins.lualine.enable = true;
    plugins.treesitter = {
      enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        nix
	lua
	toml
	vim
	vimdoc
	rust
      ];
    };
    plugins.telescope = {
      enable = true;
      keymaps = {
       "<leader>sk" = {
          mode = "n";
          action = "keymaps";
          options = {
            desc = "[S]earch [K]eymaps";
          };
        };
      };
    };
    plugins.web-devicons.enable = true;
    plugins.which-key = {
      enable = true;


    };

}
