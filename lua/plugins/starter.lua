return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[If you are not failing 90% of the time, you are not aiming high enough.]],
      [[                                                                 -Alan Kay]],
      [[                                                                       ]],
    }
    -- dashboard.section.header.opts.position = "center"
    -- dashboard.section.mru.align = "center"
    local snacks = require("snacks")

    dashboard.section.buttons.val = {
      dashboard.button("e", "📄  New File", ":ene <BAR> startinsert <CR>"),
      dashboard.button("r", "🕘  Recent Files", function() snacks.picker.recent() end),
      dashboard.button("q", "🚪  Quit", ":qa<CR>"),
    }
    dashboard.section.buttons.opts.position = "center"
    -- create a dynamic footer
    local footer = {
      type = "text",
      val = "",
      opts = {
        position = "center",
        hl = "Type",
      },
    }


    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()

        vim.defer_fn(function()
          local plugins_count = #vim.tbl_keys(require("lazy").plugins())
          local version = vim.version()
          local nvim_version_info = "v" .. version.major .. "." .. version.minor .. "." .. version.patch
          
          -- get lazy stats
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          
          -- update footer content
          local new_footer = string.format("⚡ Neovim %s loaded %d plugins in %.1f ms", 
            nvim_version_info, plugins_count, ms)
          
          -- set footer text
          dashboard.section.footer.val = new_footer
          
          if vim.bo.filetype == "alpha" then
            vim.cmd("AlphaRedraw")
          end
        end, 10)
      end,
      once = true,
    })

    dashboard.section.footer.val = " "
    dashboard.section.footer.opts.position = "center"

    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    alpha.setup(dashboard.opts)
    
    vim.api.nvim_create_user_command("AlphaRedraw", function()
      require("alpha").redraw()
    end, {})
  end,
}