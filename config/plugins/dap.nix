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
    envFile = ''''${workspaceFolder}/.env-docker'';
    stopOnEntry = false;
  };
in
{
  plugins.dap-lldb = {
    enable = true;
  };
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

  # https://nix-community.github.io/nixvim/keymaps/index.html
  keymaps = [
    {
      mode = "n";
      key = "<F5>";
      action.__raw = ''
        function()
          require('dap').continue()
        end
      '';
      options = {
        desc = "Debug: Start/Continue";
      };
    }
    {
      mode = "n";
      key = "<F1>";
      action.__raw = ''
        function()
          require('dap').step_into()
        end
      '';
      options = {
        desc = "Debug: Step Into";
      };
    }
    {
      mode = "n";
      key = "<F2>";
      action.__raw = ''
        function()
          require('dap').step_over()
        end
      '';
      options = {
        desc = "Debug: Step Over";
      };
    }
    {
      mode = "n";
      key = "<F3>";
      action.__raw = ''
        function()
          require('dap').step_out()
        end
      '';
      options = {
        desc = "Debug: Step Out";
      };
    }
    {
      mode = "n";
      key = "<leader>b";
      action.__raw = ''
        function()
          require('dap').toggle_breakpoint()
        end
      '';
      options = {
        desc = "Debug: Toggle Breakpoint";
      };
    }
    {
      mode = "n";
      key = "<leader>B";
      action.__raw = ''
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end
      '';
      options = {
        desc = "Debug: Set Breakpoint";
      };
    }
    # Toggle to see last session result. Without this, you can't see session output
    # in case of unhandled exception.
    {
      mode = "n";
      key = "<F7>";
      action.__raw = ''
        function()
          require('dapui').toggle()
        end
      '';
      options = {
        desc = "Debug: See last session result.";
      };
    }
  ];

  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraconfiglua#extraconfiglua
  extraConfigLua = ''
    require('dap').listeners.after.event_initialized['dapui_config'] = require('dapui').open
    require('dap').listeners.before.event_terminated['dapui_config'] = require('dapui').close
    require('dap').listeners.before.event_exited['dapui_config'] = require('dapui').close
  '';
}
