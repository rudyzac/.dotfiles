-- Set leader key
vim.g.mapleader = " "

-- Enable line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Set indentation options
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Enable syntax highlighting and colors
vim.opt.termguicolors = true

-- Enable mouse support in all modes
vim.opt.mouse = "a"

-- ==============================
-- Key mappings
-- ==============================
vim.keymap.set("n", "<leader><leader>w", "<Plug>(easymotion-bd-w)", { noremap = false, silent = true }) -- Double leader for EasyMotion

-- ==============================
-- Bootstrap Lazy.nvim if not installed
-- ==============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==============================
-- Plugin setup with Lazy.nvim
-- ==============================
require("lazy").setup({
  -- EasyMotion plugin
  "easymotion/vim-easymotion",

  -- Example plugins you already planned
  "nvim-treesitter/nvim-treesitter",  -- Treesitter for syntax highlighting
  "nvim-lualine/lualine.nvim",        -- Lualine for status line
})
