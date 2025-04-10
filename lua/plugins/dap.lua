-- TODO: not working yet
local dap_breakpoint = {
  error = {
      text = " ",
      texthl = "DapBreakpoint",
      linehl = "DapBreakpoint",
      numhl = "DapBreakpoint",
  },
  condition = {
      text = ' ',
      texthl = 'DapBreakpoint',
      linehl = 'DapBreakpoint',
      numhl = 'DapBreakpoint',
  },
  rejected = {
      text = " ",
      texthl = "DapBreakpint",
      linehl = "DapBreakpoint",
      numhl = "DapBreakpoint",
  },
  logpoint = {
      text = '.>',
      texthl = 'DapLogPoint',
      linehl = 'DapLogPoint',
      numhl = 'DapLogPoint',
  },
  stopped = {
      text = '󰁕',
      texthl = 'DapStopped',
      linehl = 'DapStopped',
      numhl = 'DapStopped',
  },
}

return {
	"mfussenegger/nvim-dap",
	dependencies = {
    "mfussenegger/nvim-dap-python",
		"rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
	},
  keys = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    -- { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
    { "<leader>dx", function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" },
    { "<leader>dy", function() require("dap").close() end, desc = "Close" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")


    -- Python DAP adapter configuration
    dap.adapters.python = function(cb, config)
      if config.request == "attach" then
        local port = (config.connect or config).port
        local host = (config.connect or config).host or "127.0.0.1"
        cb({
          type = "server",
          port = assert(port, "`connect.port` is required for a python `attach` configuration"),
          host = host,
          options = { source_filetype = "python" },
        })
      else
        cb({
          type = "executable",
          -- Adjust this path to your debugpy installation
          command = "C:\\Users\\Admin\\AppData\\Local\\nvim-data\\mason\\packages\\debugpy\\venv\\Scripts\\pythonw",
          args = { "-m", "debugpy.adapter" },
          options = { source_filetype = "python" },
        })
      end
    end

    -- Python DAP configuration
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}", -- Debug current file
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
            return cwd .. "/venv/bin/python"
          elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
            return cwd .. "/.venv/bin/python"
          else
            -- Adjust this path to your Python executable
            return "C:\\Users\\Admin\\AppData\\Local\\nvim-data\\mason\\packages\\debugpy\\venv\\Scripts\\pythonw"
          end
        end,
      },
    }


    -- C++ DAP adapter configuration (using GDB)
    dap.adapters.cppdbg = {
      id = "cppdbg",
      type = "executable",
      -- Adjust this path to where gdb.exe is installed on your system
      command = "D:\\Program Files (x86)\\w64devkit\\bin\\gdb.exe", -- Example path for MinGW GDB on Windows
      options = {
        detached = false, -- Run GDB in the same terminal
      },
    }

    -- C++ DAP configuration
    dap.configurations.cpp = {
      {
        name = "Launch GDB",
        type = "cppdbg",
        request = "launch",
        program = function()
          -- Prompt for the executable path or use a default
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}", -- Current working directory
        stopAtEntry = true,        -- Stop at program entry (main)
        setupCommands = {          -- Optional GDB setup commands
          {
            text = "-enable-pretty-printing",
            description = "Enable pretty-printing",
            ignoreFailures = true,
          },
        },
      },
    }

    -- Reuse the same configuration for C (since GDB works for both)
    dap.configurations.c = dap.configurations.cpp

    vim.fn.sign_define('DapBreakpoint', dap_breakpoint.error)
    vim.fn.sign_define('DapBreakpointCondition', dap_breakpoint.condition)
    vim.fn.sign_define('DapBreakpointRejected', dap_breakpoint.rejected)
    vim.fn.sign_define('DapLogPoint', dap_breakpoint.logpoint)
    vim.fn.sign_define('DapStopped', dap_breakpoint.stopped)

    require("dapui").setup()
    require("dap-python").setup()
    require("nvim-dap-virtual-text").setup({
      enabled = true,
      enable_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      filter_references_pattern = '<module',
      virt_text_pos = 'eol',
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil
  })

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

  end,
}