-- return {
--   "nvim-neo-tree/neo-tree.nvim",
--   branch = "v3.x",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-tree/nvim-web-devicons",
--     "MunifTanjim/nui.nvim",
--   },
--   keys = {
--     { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle File Tree" },
--   },
--   opts = {
--     filesystem = {
--       follow_current_file = { enabled = true },
--       hijack_netrw_behavior = "open_default",
--     },
--     window = {
--       mappings = {
--         ["l"] = "open",       
--         ["h"] = "toggle_node",  
--         ["<BS>"] = "navigate_up",
--       },
--     },
--   },
-- }

-- return {
-- 	"nvim-tree/nvim-tree.lua",
-- 	dependencies = "nvim-tree/nvim-web-devicons",
-- 	enable = false,
-- 	config = function()
-- 		local nvimtree = require("nvim-tree")

-- 		-- recommended settings from nvim-tree documentation
-- 		vim.g.loaded_netrw = 1
-- 		vim.g.loaded_netrwPlugin = 1

-- 		nvimtree.setup({
-- 			view = {
-- 				width = 35,
-- 				relativenumber = true,
-- 			},
-- 			-- change folder arrow icons
-- 			renderer = {
-- 				indent_markers = {
-- 					enable = true,
-- 				},
-- 				icons = {
-- 					glyphs = {
-- 						folder = {
-- 							arrow_closed = "", -- arrow when folder is closed
-- 							arrow_open = "", -- arrow when folder is open
-- 						},
-- 					},
-- 				},
-- 			},
-- 			-- disable window_picker for
-- 			-- explorer to work well with
-- 			-- window splits
-- 			actions = {
-- 				open_file = {
-- 					window_picker = {
-- 						enable = false,
-- 					},
-- 				},
-- 			},
-- 			filters = {
-- 				custom = { ".DS_Store" },
-- 			},
-- 			git = {
-- 				ignore = false,
-- 			},
-- 		})

-- 		-- set keymaps
-- 		local keymap = vim.keymap -- for conciseness

-- 		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
-- 		keymap.set(
-- 			"n",
-- 			"<leader>ef",
-- 			"<cmd>NvimTreeFindFileToggle<CR>",
-- 			{ desc = "Toggle file explorer on current file" }
-- 		) -- toggle file explorer on current file
-- 		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
-- 		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
-- 	end,
-- }


return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle Explorer" },},
  --   { "<leader>o", function()
  --     if vim.bo.filetype == "neo-tree" then
  --       vim.cmd.wincmd "p"
  --     else
  --       vim.cmd.Neotree "focus"
  --     end
  --   end, desc = "Toggle Explorer Focus" },
  -- },
  init = function()
    -- automatically open Neo-Tree on startup if the current buffer is a directory
    vim.api.nvim_create_autocmd("BufEnter", {
      desc = "Open Neo-Tree on startup with directory",
      callback = function()
        if package.loaded["neo-tree"] then
          return true
        else
          local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(0))
          if stats and stats.type == "directory" then
            require("lazy").load { plugins = { "neo-tree.nvim" } }
            return true
          end
        end
      end,
    })

    -- automatically refresh Neo-Tree sources when closing lazygit
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit*",
      desc = "Refresh Neo-Tree sources when closing lazygit",
      callback = function()
        local manager_avail, manager = pcall(require, "neo-tree.sources.manager")
        if manager_avail then
          for _, source in ipairs { "filesystem", "git_status", "document_symbols" } do
            local module = "neo-tree.sources." .. source
            if package.loaded[module] then manager.refresh(require(module).name) end
          end
        end
      end,
    })
  end,
  opts = function()
    local git_available = vim.fn.executable "git" == 1
    
    -- custom icons for Neo-Tree
    -- you can customize these icons to your liking
    local icons = {
      FolderClosed = "",
      FolderOpen = "",
      FolderEmpty = "",
      DefaultFile = "",
      FileModified = "●",
      Git = "",
      GitAdd = "",
      GitDelete = "",
      GitChange = "",
      GitRenamed = "➜",
      GitUntracked = "★",
      GitIgnored = "◌",
      GitUnstaged = "✗",
      GitStaged = "✓",
      GitConflict = "",
      Diagnostic = "",
      FoldClosed = "▶",
      FoldOpened = "▼",
    }

    local sources = {
      { source = "filesystem", display_name = icons.FolderClosed .. " File" },
      { source = "buffers", display_name = icons.DefaultFile .. " Bufs" },
      { source = "diagnostics", display_name = icons.Diagnostic .. " Diagnostic" },
    }
    if git_available then
      table.insert(sources, 3, { source = "git_status", display_name = icons.Git .. " Git" })
    end

    return {
      enable_git_status = git_available,
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      sources = { "filesystem", "buffers", git_available and "git_status" or nil },
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = sources,
      },
      default_component_configs = {
        indent = {
          padding = 0,
          expander_collapsed = icons.FoldClosed,
          expander_expanded = icons.FoldOpened,
        },
        icon = {
          folder_closed = icons.FolderClosed,
          folder_open = icons.FolderOpen,
          folder_empty = icons.FolderEmpty,
          folder_empty_open = icons.FolderEmpty,
          default = icons.DefaultFile,
        },
        modified = { symbol = icons.FileModified },
        git_status = {
          symbols = {
            added = icons.GitAdd,
            deleted = icons.GitDelete,
            modified = icons.GitChange,
            renamed = icons.GitRenamed,
            untracked = icons.GitUntracked,
            ignored = icons.GitIgnored,
            unstaged = icons.GitUnstaged,
            staged = icons.GitStaged,
            conflict = icons.GitConflict,
          },
        },
      },
      commands = {
        system_open = function(state) vim.ui.open(state.tree:get_node():get_id()) end,
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if node:has_children() and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node:has_children() then
            if not node:is_expanded() then
              state.commands.toggle_node(state)
            else
              if node.type == "file" then
                state.commands.open(state)
              else
                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
              end
            end
          else
            state.commands.open(state)
          end
        end,
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local vals = {
            ["BASENAME"] = modify(filename, ":r"),
            ["EXTENSION"] = modify(filename, ":e"),
            ["FILENAME"] = filename,
            ["PATH (CWD)"] = modify(filepath, ":."),
            ["PATH (HOME)"] = modify(filepath, ":~"),
            ["PATH"] = filepath,
            ["URI"] = vim.uri_from_fname(filepath),
          }

          local options = vim.tbl_filter(function(val) return vals[val] ~= "" end, vim.tbl_keys(vals))
          if vim.tbl_isempty(options) then
            vim.notify("No values to copy", vim.log.levels.WARN)
            return
          end
          table.sort(options)
          vim.ui.select(options, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item) return ("%s: %s"):format(item, vals[item]) end,
          }, function(choice)
            local result = vals[choice]
            if result then
              vim.notify(("Copied: `%s`"):format(result))
              vim.fn.setreg("+", result)
            end
          end)
        end,
      },
      window = {
        width = 30,
        mappings = {
          ["<S-CR>"] = "system_open",
          ["<Space>"] = false,
          ["[b"] = "prev_source",
          ["]b"] = "next_source",
          O = "system_open",
          Y = "copy_selector",
          h = "parent_or_close",
          l = "child_or_open",
        },
        fuzzy_finder_mappings = {
          ["<C-J>"] = "move_cursor_down",
          ["<C-K>"] = "move_cursor_up",
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        filtered_items = { hide_gitignored = git_available },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = vim.fn.has "win32" ~= 1,
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.opt_local.signcolumn = "auto"
            vim.opt_local.foldcolumn = "0"
          end,
        },
      },
    }
  end,
}