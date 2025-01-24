{pkgs, ...}:{
  # Import all your configuration modules here
  imports = [ 
    ./plugins/dap.nix
    ./plugins/lsp-cmp.nix
    ./plugins/lsp.nix
    ./plugins/telescope.nix
      
  ];
  globals.mapleader = " ";
    globals.clipboard = {
      copy = {
        "+" = ["yank.exe -i --crlf"];
        "*" = ["yank.exe -i --crlf"];
      };
      paste = {
        "+" = ["yank.exe -o --lf"]; 
        "*" = ["yank.exe -o --lf"]; 
      };
      cache_enabled = 0;
    };

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
    plugins.luasnip.enable = true;
   plugins.web-devicons.enable = true;
    plugins.which-key = {
      enable = true;


    };

}
