return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        cpp = { "clang-format" },
        c = { "clang-format" },
        rust = { "rustfmt" },
      },
      format_on_save = {
        lsp_fallback = false, -- Disable if LSP doesn’t format Python
        async = false,
        timeout_ms = 2000,    -- Increased timeout
      },
      -- Optional: Specify formatter options
      formatters = {
        clang_format = { args = { "--style=llvm" } }, -- Use LLVM style
        black = { prepend_args = { "--fast" } }, -- Faster black formatting
        isort = { prepend_args = { "--profile", "black" } }, -- Compatible with black
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = false,
        async = false,
        timeout_ms = 2000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}