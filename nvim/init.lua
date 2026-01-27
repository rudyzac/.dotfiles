-- Set leader key
vim.g.mapleader = " "

-- Disable netrw to prevent conflicts with Neo-tree (must be set before plugins are loaded)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
-- Neo-tree key mappings
-- ==============================
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { silent = true }) -- Open/close file explorer
vim.keymap.set("n", "<leader>o", ":Neotree focus<CR>", { silent = true })  -- Jump to explorer window

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

  -- Treesitter for syntax highlighting
  "nvim-treesitter/nvim-treesitter",

  -- Lualine for status line
  "nvim-lualine/lualine.nvim",

  -- ==============================
  -- Neo-tree (file explorer)
  -- ==============================
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- icons
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          follow_current_file = true,
          hijack_netrw_behavior = "open_default",
        },
        window = {
          width = 30,
        },
      })
    end,
  },
})

