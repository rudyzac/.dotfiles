-- Set leader key
vim.g.mapleader = " "

-- Disable netrw to prevent conflicts with Neo-tree (must be set before plugins are loaded)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Set indentation options (2 spaces by default)
vim.opt.expandtab = true    -- turn tabs into spaces
vim.opt.shiftwidth = 2      -- spaces per indent level (>>, <<, autoindent)
vim.opt.tabstop = 2         -- visual width of a literal <Tab>
vim.opt.softtabstop = 2     -- spaces inserted when pressing <Tab> in insert mode

-- Enable syntax highlighting and colors
vim.opt.termguicolors = true

-- Enable mouse support in all modes
vim.opt.mouse = "a"

-- Case-insensitive search, unless the pattern contains an uppercase letter
vim.opt.ignorecase = true   -- searches ignore case by default
vim.opt.smartcase = true    -- ...but become case-sensitive when the pattern has a capital

-- Don't soft-wrap long lines; let them run off-screen (better for code)
vim.opt.wrap = false

-- Use the system clipboard for yank/delete/paste
vim.opt.clipboard = "unnamedplus"

-- Open new splits to the right and below
vim.opt.splitright = true   -- vertical splits open to the right
vim.opt.splitbelow = true   -- horizontal splits open below

-- Exit insert mode by typing "jk" (keeps hands on the home row)
vim.keymap.set("i", "jk", "<ESC>", { silent = true })

-- ==============================
-- Window navigation
-- ==============================
-- Move between splits with Option+h/j/k/l instead of the Ctrl-w prefix
vim.keymap.set("n", "<A-h>", "<C-w>h", { silent = true }) -- to the split on the left
vim.keymap.set("n", "<A-j>", "<C-w>j", { silent = true }) -- to the split below
vim.keymap.set("n", "<A-k>", "<C-w>k", { silent = true }) -- to the split above
vim.keymap.set("n", "<A-l>", "<C-w>l", { silent = true }) -- to the split on the right

-- Manage splits
vim.keymap.set("n", "<leader>sv", "<C-w>v", { silent = true }) -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s", { silent = true }) -- split window horizontally
vim.keymap.set("n", "<leader>sx", "<C-w>q", { silent = true }) -- close current split

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
-- Barbar (buffer tabline) key mappings
-- ==============================
vim.keymap.set("n", "<C-h>", "<Cmd>BufferPrevious<CR>", { silent = true })      -- Previous buffer
vim.keymap.set("n", "<C-l>", "<Cmd>BufferNext<CR>", { silent = true })          -- Next buffer
vim.keymap.set("n", "<C-x>", "<Cmd>BufferClose<CR>", { silent = true })         -- Close current buffer
vim.keymap.set("n", "<C-p>", "<Cmd>BufferPick<CR>", { silent = true })     -- Pick a buffer (jump by letter)

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
  -- ==============================
  -- Colorscheme (VS Code Dark+) — active default
  -- ==============================
  {
    "Mofiqul/vscode.nvim",
    lazy = false,    -- load during startup
    priority = 1000, -- load before other plugins so highlights apply
    config = function()
      require("vscode").setup({
        style = "dark", -- dark | light
      })
      vim.cmd.colorscheme("vscode")
    end,
  },

  -- ==============================
  -- Colorscheme (Tokyo Night) — installed but inactive; switch with
  -- `:colorscheme tokyonight`.
  -- ==============================
  {
    "folke/tokyonight.nvim",
    lazy = false,
    config = function()
      require("tokyonight").setup({
        style = "night", -- night | storm | moon | day
      })
    end,
  },

  -- ==============================
  -- Treesitter (AST-based syntax highlighting)
  -- ==============================
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      -- The legacy `master` branch hardcodes `--no-bindings`, which the modern
      -- tree-sitter CLI (0.25+) rejects. Override the generate args to drop it
      -- while still targeting the ABI our Neovim expects. Only affects the few
      -- parsers built from grammar (e.g. swift).
      require("nvim-treesitter.install").ts_generate_args = {
        "generate", "--abi", vim.treesitter.language_version,
      }

      require("nvim-treesitter.configs").setup({
        -- Parsers installed automatically when you open a file of that type
        auto_install = true,
        -- Or list specific languages to always have installed
        ensure_installed = { "lua", "vim", "vimdoc", "bash", "swift" },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },

  -- ==============================
  -- Flash (enhanced motion / search-based jumping)
  -- ==============================
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      highlight = {
        backdrop = false, -- don't dim the rest of the buffer while jumping
      },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = "c", function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- ==============================
  -- Lualine (status line)
  -- ==============================
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- icons
    },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",      -- follow the active colorscheme (vscode/tokyonight)
          globalstatus = true, -- one statusline for the whole window, not per-split
        },
      })
    end,
  },

  -- ==============================
  -- Gitsigns (git status in the gutter + buffer git state for barbar)
  -- ==============================
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        -- Show blame (author, date, summary) as faint text at the end of the
        -- current line. Toggle with <leader>htb.
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- at the end of the line
          delay = 100,           -- ms after the cursor settles
        },
        current_line_blame_formatter = "  <author>, <author_time:%Y-%m-%d> · <summary>",
        on_attach = function(bufnr)
          local gs = require("gitsigns")
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
          end

          -- Navigation between hunks
          map("n", "]c", function() gs.nav_hunk("next") end, "Next git hunk")
          map("n", "[c", function() gs.nav_hunk("prev") end, "Previous git hunk")

          -- Hunk actions
          map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
          map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
          map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage selection")
          map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset selection")
          map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
          map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
          -- `stage_hunk` toggles: run it again on a staged hunk to unstage.
          map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")

          -- Blame & diff
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
          map("n", "<leader>hd", gs.diffthis, "Diff against index")

          -- Toggles
          map("n", "<leader>htb", gs.toggle_current_line_blame, "Toggle line blame")
          map("n", "<leader>htd", gs.toggle_deleted, "Toggle deleted")
        end,
      })
    end,
  },

  -- ==============================
  -- Barbar (buffer tabline)
  -- ==============================
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- file icons
      "lewis6991/gitsigns.nvim",     -- git status in the tabline
    },
    init = function()
      vim.g.barbar_auto_setup = false -- we call setup via `opts` below
    end,
    opts = {
      -- Offset the tabline while Neo-tree's sidebar is open so tabs sit
      -- above the editor, not over the file explorer.
      sidebar_filetypes = {
        ["neo-tree"] = { event = "BufWipeout" },
      },
      -- Show per-buffer git status in the tabline (off by default).
      icons = {
        gitsigns = {
          added = { enabled = true, icon = "+" },
          changed = { enabled = true, icon = "~" },
          deleted = { enabled = true, icon = "-" },
        },
      },
    },
    version = "^1.0.0", -- only pull tagged 1.x releases
  },

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

  -- ==============================
  -- Autopairs (auto-close brackets, quotes, etc.)
  -- ==============================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})

      -- Insert () after confirming a function/method completion in nvim-cmp.
      local ok, cmp = pcall(require, "cmp")
      if ok then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- ==============================
  -- Multicursor (multiple cursors, VS Code style)
  -- ==============================
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      -- (Ctrl+arrows instead of plain arrows, so arrow-key navigation is untouched.)
      set({ "n", "x" }, "<C-Up>", function() mc.lineAddCursor(-1) end)
      set({ "n", "x" }, "<C-Down>", function() mc.lineAddCursor(1) end)
      set({ "n", "x" }, "<leader><C-Up>", function() mc.lineSkipCursor(-1) end)
      set({ "n", "x" }, "<leader><C-Down>", function() mc.lineSkipCursor(1) end)

      -- Add or skip a cursor by matching the word/selection under the cursor.
      set({ "n", "x" }, "<leader>n", function() mc.matchAddCursor(1) end)   -- next match
      set({ "n", "x" }, "<leader>N", function() mc.matchAddCursor(-1) end)  -- previous match
      -- (skip on <leader>k/<leader>K to avoid clashing with the <leader>s split maps)
      set({ "n", "x" }, "<leader>k", function() mc.matchSkipCursor(1) end)  -- skip next match
      set({ "n", "x" }, "<leader>K", function() mc.matchSkipCursor(-1) end) -- skip previous match

      -- Add and remove cursors with Ctrl + left click.
      set("n", "<c-leftmouse>", mc.handleMouse)
      set("n", "<c-leftdrag>", mc.handleMouseDrag)
      set("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Disable and enable cursors.
      set({ "n", "x" }, "<c-q>", mc.toggleCursor)

      -- Mappings that only apply while there are multiple cursors.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        -- (Ctrl+Left/Right so plain arrows stay free for motion/selection.)
        layerSet({ "n", "x" }, "<C-Left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<C-Right>", mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

        -- Esc: re-enable disabled cursors, otherwise collapse back to one cursor.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
})
