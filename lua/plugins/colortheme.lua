-- return {
--   "folke/tokyonight.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("tokyonight").setup({
--       style = "moon",
--       transparent = false,
--       terminal_colors = true,
--     })
--     vim.cmd([[colorscheme tokyonight]])
--   end,
-- }
--
--


return {
  'sainnhe/everforest',
  priority = 1000,
  config = function()
    vim.g.everforest_diagnostic_line_highlight = 1
    vim.cmd [[colorscheme everforest]]
  end,
}
