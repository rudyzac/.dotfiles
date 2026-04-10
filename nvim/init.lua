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
-- Telescope key mappings
-- ==============================
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { silent = true }) -- Find files
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { silent = true })  -- Live grep
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { silent = true })    -- List buffers
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { silent = true })  -- Help tags

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
  -- Syntax support for many languages
  "sheerun/vim-polyglot",

  -- EasyMotion plugin
  "easymotion/vim-easymotion",

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
          follow_current_file = {
            enabled = true,
          },
          filtered_items = {
            hide_dotfiles = false, -- show hidden files
            hide_gitignored = false,
          },
          hijack_netrw_behavior = "open_default",
        },
        window = {
          width = 30,
        },
      })
    end,
  },

  -- ==============================
  -- Telescope (fuzzy finder)
  -- ==============================
  {
    "nvim-telescope/telescope.nvim", version = '*',
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
              ["<C-j>"] = require("telescope.actions").move_selection_next,
            },
          },
        },
      })
      telescope.load_extension("fzf")
    end,
  },

  -- ==============================
  -- LSP Configuration (nvim-lspconfig)
  -- ==============================
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("config.lsp")
    end,
  },

  -- ==============================
  -- Completion (nvim-cmp)
  -- ==============================
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",  -- Only loads when entering insert mode (speeds up startup time)
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",      -- LSP source for nvim-cmp
      "hrsh7th/cmp-buffer",         -- Buffer completions
      "hrsh7th/cmp-path",           -- Path completions
      "L3MON4D3/LuaSnip",           -- Snippet engine
      "saadparwaiz1/cmp_luasnip",   -- Luasnip source for nvim-cmp
      "rafamadriz/friendly-snippets", -- Snippet collection
    },
    config = function()
      require("config.completion")
    end,
  },
})
