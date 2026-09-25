-- LSP Configuration
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Get capabilities from cmp_nvim_lsp
local capabilities = cmp_nvim_lsp.default_capabilities()

-- ==============================
-- Hover float border
-- ==============================

-- The hover float gets its own border colour instead of the shared FloatBorder,
-- so it reads as a distinct window rather than blending into the buffer. A
-- border passed as { char, highlight } cells is the only way to colour one
-- float differently from the rest -- the string forms ("rounded", "single")
-- all draw with FloatBorder, which every other float uses too.
local function hover_border()
  -- Clockwise from the top-left corner, as nvim_open_win expects.
  return {
    { "╭", "LspHoverBorder" },
    { "─", "LspHoverBorder" },
    { "╮", "LspHoverBorder" },
    { "│", "LspHoverBorder" },
    { "╯", "LspHoverBorder" },
    { "─", "LspHoverBorder" },
    { "╰", "LspHoverBorder" },
    { "│", "LspHoverBorder" },
  }
end

-- VS Code's type teal: bright enough to frame the float on the dark background,
-- and unused by the rainbow-delimiter groups in init.lua.
local function apply_hover_highlight()
  vim.api.nvim_set_hl(0, "LspHoverBorder", { fg = "#4ec9b0" })
end

apply_hover_highlight()
-- Re-apply after any colorscheme switch, which clears custom groups.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("LspHoverColors", { clear = true }),
  callback = apply_hover_highlight,
})

-- Configure LSP keymaps for when a buffer is attached
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- Hover documentation. Press K again to jump into the float and scroll it.
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover({ border = hover_border() })
  end, opts)

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

  -- Formatting (only bound on servers that advertise the capability)
  if client:supports_method("textDocument/formatting") then
    -- Format the whole buffer (or the selection, in visual mode)
    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end
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

-- Terraform Language Server (requires terraform-ls)
-- brew install hashicorp/tap/terraform-ls
vim.lsp.config("terraformls", {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    -- lspconfig's shipped terraformls config turns on codelens in its own
    -- on_attach; setting on_attach here replaces that, so re-enable it.
    vim.lsp.codelens.enable(true, { bufnr = bufnr })
  end,
  capabilities = capabilities,
})

-- TypeScript/JavaScript Language Server (requires vtsls)
-- brew install vtsls
-- Handles .js, .jsx, .ts, .tsx, .mjs and .cjs.
--
-- vtsls over ts_ls: it wraps VS Code's TypeScript extension rather than reimplementing
-- the protocol shim, and resolves each package's tsconfig.json inside a single server
-- instance instead of spawning one client per root. Do not enable ts_ls alongside it —
-- they drive the same tsserver and would double every diagnostic.
vim.lsp.config("vtsls", {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- ESLint Language Server (requires vscode-eslint-language-server)
-- brew install vscode-langservers-extracted
--
-- Complements vtsls rather than competing with it: vtsls reports type errors, eslint
-- reports lint rules and offers autofixes. It only starts when it finds an eslint
-- config in the tree, so projects without one are unaffected.
--
-- lspconfig's shipped eslint config registers :LspEslintFixAll in its own on_attach;
-- setting on_attach here replaces that, so capture the shipped one and call through.
local eslint_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config("eslint", {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    eslint_on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  settings = {
    -- Default is true, which makes eslint advertise textDocument/formatting. Both it
    -- and vtsls attach to the same buffer, so <leader>cf would then run two formatters
    -- over it and let them fight. Leave formatting to vtsls; apply eslint's fixes with
    -- :LspEslintFixAll instead.
    format = false,
  },
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
vim.lsp.enable({ "lua_ls", "sourcekit", "jsonls", "marksman", "terraformls", "vtsls", "eslint" })
