-- Neovim's bundled ftplugin/swift.vim forces 4-space indents.
-- The Swift standard library uses 2, so put it back.
-- (The LSP client sends these as tabSize/insertSpaces, so sourcekit-lsp
-- formats to 2 spaces too.)
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.tabstop = 2
vim.bo.expandtab = true
