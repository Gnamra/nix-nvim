{ pkgs, lib, ... }:
let 
  lldb-config = {
    name = "Launch (LLDB)";
    type = "lldb";
    request = "launch";
    program.__raw = ''
      function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. '/', "file")
      end'';
    cwd = ''''${workspaceFolder}'';
    stopOnEntry = false;
  };
in
{
  plugins.dap = {
    enable = true;

    adapters = {

      executables = {
        lldb = {
          command = lib.getExe' pkgs.lldb "lldb-dap";
        };
      };

      servers = {
        codelldb = {
          port = 13000;
          executable = {
            command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
            args = [
              "--port"
              "13000"
            ];
          };
        };
      };
    };

    signs = {
      dapBreakpoint = {
        text = "🛑";
        texthl = "DiagnosticInfo";
      };
    };
    configurations = {
      rust = [lldb-config];

    };

    extensions = {
      dap-ui = {
        enable = true;
        
        # Set icons to characters that are more likely to work in every terminal.
        # Feel free to remove or use ones that you like more! :)
        # Don't feel like these are good choices.
        icons = {
          expanded = "▾";
          collapsed = "▸";
          current_frame = "*";
        };

        controls = {
          icons = {
            pause = "⏸";
            play = "▶";
            step_into = "⏎";
            step_over = "⏭";
            step_out = "⏮";
            step_back = "b";
            run_last = "▶▶";
            terminate = "⏹";
            disconnect = "⏏";
          };
        };
      };

      dap-virtual-text = {
        enable = false;
      };
    };
  };
}
