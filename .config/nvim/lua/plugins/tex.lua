-- ============================================================
-- LaTeX & VimTeX
-- ============================================================

return {

  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      -- macOS Specific: Skim Configuration
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_activate = 1
      vim.g.vimtex_view_skim_sync = 1

      -- Compiler Settings
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_quickfix_ignore_filters = {
        'Underfull',
        'Overfull',
        'specifier changed to',
      }
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "iurimateus/luasnip-latex-snippets.nvim",
    },
    config = function()
      local ls = require("luasnip")
      ls.setup({ enable_autosnippets = true })

      -- Load LaTeX specific pre-made snippets
      require('luasnip-latex-snippets').setup({ use_treesitter = true })

      -- Load your custom snippets from ~/.config/nvim/snippets/
      require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets/" })
    end,
  },

}
