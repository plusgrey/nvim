-- return {
--     {
--         "zbirenbaum/copilot.lua",
--         cmd = "Copilot",
--         event = "InsertEnter",
--         config = function()
--             require("copilot").setup({
--                 suggestion = { 
--                     enabled = true,
--                     auto_trigger = true,
--                     keymap = {
--                         accept = "<Tab>",
--                         accept_word = "<A-w>",
--                         accept_line = "<A-p>",
--                         next = "<A-j>",
--                         prev = "<A-k>", 
--                         dismiss = "<A-l>",
--                     }
--                 },
--                 panel = { enabled = false },
--             })
--         end,
--     },
-- }


return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "BufReadPost",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = false, -- handle by blink
        accept_word = "<A-w>",
        accept_line = "<A-p>",
        next = "<M-j>",
        prev = "<M-k>",
        dismiss = "<C-]>",
      },
    },
  },
  config = function(_, opts)
    local copilot = require("copilot.suggestion")
    require("copilot").setup(opts)

    -- define a function to accept Copilot suggestions
    vim.g.ai_accept = function()
      if copilot.is_visible() then
        copilot.accept()
        return true
      end
      return false
    end

    -- optional: set up key to trigger Copilot suggestion manually
    vim.keymap.set("i", "<M-CR>", function()
      if vim.g.ai_accept() then return end
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
    end, { desc = "Accept Copilot suggestion or insert newline" })
  end,
}