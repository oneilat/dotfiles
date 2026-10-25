-- ============================================================
-- Diagnostics
-- ============================================================

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
})

local map = vim.keymap.set

map("n", "<leader>e", vim.diagnostic.open_float)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)
