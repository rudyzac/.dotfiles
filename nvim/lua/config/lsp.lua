-- LSP Configuration
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Get capabilities from cmp_nvim_lsp
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Configure LSP keymaps for when a buffer is attached
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- Hover documentation
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

  -- Go to definition
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

  -- Go to declaration
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

  -- Go to implementation
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

  -- Go to type definition
  vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)

  -- Find references
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

  -- Code actions
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

  -- Rename symbol
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

  -- Show diagnostics in floating window
  vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

  -- Jump to next diagnostic
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

  -- Jump to previous diagnostic
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

  -- Show signature help
  vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
end

-- ==============================
-- Language Server Setups
-- ==============================

-- Lua Language Server
vim.lsp.config("lua_ls", {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
    },
  },
})

-- Swift Language Server
vim.lsp.config("sourcekit", {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- JSON Language Server
vim.lsp.config("jsonls", {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Markdown Language Server (requires marksman)
-- brew install marksman (or see https://github.com/artempyanykh/marksman)
vim.lsp.config("marksman", {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- ==============================
-- Diagnostics Configuration
-- ==============================

-- Configure diagnostics appearance
vim.diagnostic.config({
  virtual_text = true,
  float = {
    source = "always",
    border = "rounded",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

-- Set diagnostic signs
local signs = { Error = "󰅙", Warn = "󰀪", Hint = "󰌶", Info = "󰋽" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Enable the configured language servers
vim.lsp.enable({ "lua_ls", "sourcekit", "jsonls", "marksman" })
