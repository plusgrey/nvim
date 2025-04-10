-- Set Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Insert Mode: jk -> <Esc>
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

-- Normal Mode: <S-h> -> ^
-- Normal Mode: <S-l> -> g_
vim.keymap.set("n", "<S-h>", "^", { noremap = true, silent = true })
vim.keymap.set("n", "<S-l>", "g_", { noremap = true, silent = true })

-- Normal Mode: <S-j> -> m`o<Esc>``
-- Normal Mode: <S-k> -> m`O<Esc>``
vim.keymap.set("n", "<A-j>", "m`o<Esc>``", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", "m`O<Esc>``", { noremap = true, silent = true })

-- Normal Mode: <C-h> -> <C-w>h
-- Normal Mode: <C-j> -> <C-w>j
-- Normal Mode: <C-k> -> <C-w>k
-- Normal Mode: <C-l> -> <C-w>l
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Normal Mode: <C-n> -> :nohl
vim.keymap.set("n", "<C-n>", ":nohl<CR>", { noremap = true, silent = true })

-- Normal Mode: <leader>q -> :q<CR>
-- Normal Mode: <leader>Q -> :q!<CR>
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>Q", ":q!<CR>", { noremap = true, silent = true })

-- Normal Mode: <C-s> -> :w<CR>
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })


-- Normal Mode: <leader>bn -> :bnext<CR>
-- Normal Mode: <leader>bp -> :bprevious<CR>
-- Normal Mode: <leader>bd -> :bdelete<CR>
vim.api.nvim_set_keymap("n", "<leader>bn", ":bnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>bp", ":bprevious<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>bd", ":bd!<CR>", { noremap = true, silent = true })


-- Normal Mode: <leader>ac -> :Copilot Enable<CR>
-- Normal Mode: <leader>ad -> :Copilot Disable<CR>
vim.api.nvim_set_keymap("n", "<leader>ac", ":Copilot enable<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ad", ":Copilot disable<CR>", { noremap = true, silent = true })

vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)


-- Show all diagnostics on current line in floating window
-- vim.api.nvim_set_keymap(
--   'n', '<Leader>d', ':lua vim.diagnostic.open_float()<CR>', 
--   { noremap = true, silent = true }
-- )
