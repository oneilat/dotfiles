-- ============================================================
-- Plugin entry point
-- ============================================================

require("lazy").setup({
  require("plugins.ui"),
  require("plugins.telescope"),
  require("plugins.lsp"),
  require("plugins.cmp"),
  require("plugins.misc"),
  require("plugins.tex"),
  require("plugins.database")
})
