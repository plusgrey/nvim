vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.shortmess:append("I") -- Disable intro message
vim.opt.cursorline = true

vim.opt.wrap = false
vim.opt.mouse:append("a")
vim.opt.clipboard:append("unnamedplus")

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.guicursor = "n-v-c:block-Cyan,i-ci-ve:ver25-Orange,r-cr:hor20-Green,o:hor50-Purple"
vim.cmd [[ highlight Cursor guibg=#ff0000 ]]

vim.env.PATH = vim.env.PATH .. ":/home/user/.local/share/fnm/node-versions/v20.19.0/installation/bin"