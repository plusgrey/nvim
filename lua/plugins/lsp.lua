return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local lspconfig = require("lspconfig")
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities
      })
      lspconfig.clangd.setup({
        capabilities = capabilities
      })
      lspconfig.pyright.setup({
        capabilities = capabilities
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          source = 'always',
          signs = {

            active = true,

            text = {
              [vim.diagnostic.severity.ERROR] = "✘",
              [vim.diagnostic.severity.WARN] = " ",
              [vim.diagnostic.severity.INFO] = "",
              [vim.diagnostic.severity.HINT] = "💡",
            },

            texthl = {
              [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
              [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
              [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
              [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
            },
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
    end,
  },
}

-- plugins = {
-- 	"neovim/nvim-lspconfig",
-- 	cmd = { "LspInfo", "LspInstall", "LspStart" },
-- 	event = { "BufReadPre", "BufNewFile" },
-- 	dependencies = {
-- 		{ "hrsh7th/cmp-nvim-lsp" },
-- 		{ "williamboman/mason-lspconfig.nvim" },
-- 	},
-- }

-- function plugins.config()
-- 	local lspconfig = require("lspconfig")
-- 	local lsp_defaults = lspconfig.util.default_config
-- 	local keymap = vim.keymap -- for conciseness

-- 	local signs = { Error = "✘ ", Warn = " ", Hint = "💡", Info = " " }
-- 	for type, icon in pairs(signs) do
-- 		local hl = "DiagnosticSign" .. type
-- 		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
-- 	end

-- 	lsp_defaults.capabilities =
-- 		vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

-- 	vim.api.nvim_create_autocmd("LspAttach", {
-- 		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
-- 		callback = function(ev)
-- 			-- Buffer local mappings.
-- 			-- See `:help vim.lsp.*` for documentation on any of the below functions
-- 			local opts = { buffer = ev.buf, silent = true }

-- 			-- set keybinds
-- 			opts.desc = "Show LSP references"
-- 			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

-- 			opts.desc = "Go to declaration"
-- 			keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

-- 			opts.desc = "Show LSP definitions"
-- 			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

-- 			opts.desc = "Show LSP implementations"
-- 			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

-- 			opts.desc = "Show LSP type definitions"
-- 			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

-- 			opts.desc = "See available code actions"
-- 			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

-- 			opts.desc = "Smart rename"
-- 			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

-- 			opts.desc = "Show buffer diagnostics"
-- 			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

-- 			opts.desc = "Show line diagnostics"
-- 			keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

-- 			opts.desc = "Go to previous diagnostic"
-- 			keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

-- 			opts.desc = "Go to next diagnostic"
-- 			keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

-- 			opts.desc = "Show documentation for what is under cursor"
-- 			keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

-- 			opts.desc = "Restart LSP"
-- 			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
-- 		end,
-- 	})
-- 	local default_setup = function(server)
-- 		lspconfig[server].setup({})
-- 	end

-- 	require("lspconfig").ruff.setup({
-- 		init_options = {
-- 			settings = {
-- 				-- Any extra CLI arguments for `ruff` go here.
-- 				args = {},
-- 			},
-- 		},
-- 	})
-- end

-- return plugins
