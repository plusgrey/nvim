-- Ensures that the terminal is always at the bottom of the screen 
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.cmd("wincmd J") 
  end,
})