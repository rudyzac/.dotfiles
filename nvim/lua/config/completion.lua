-- Completion Configuration (nvim-cmp)
local cmp = require("cmp")
local luasnip = require("luasnip")

-- Load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    -- Navigate completion menu
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    
    -- Scroll through documentation
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    
    -- Confirm completion
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    
    -- Abort completion menu
    ["<C-e>"] = cmp.mapping.abort(),
    
    -- Snippet navigation
    ["<Tab>"] = cmp.mapping(function()
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },      -- LSP completions
    { name = "luasnip" },       -- Snippet completions
    { name = "buffer" },        -- Buffer word completions
    { name = "path" },          -- File path completions
  }),
  formatting = {
    format = function(entry, vim_item)
      -- Add source name to completion
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
})

-- Configure completion for command mode
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" },
  }),
})

-- Configure completion for search mode
cmp.setup.cmdline("/", {
  sources = {
    { name = "buffer" },
  },
})
