-- ============================================================
-- Misc utilities
-- ============================================================

return {

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require("flash").setup()
      vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end)
    end,
  },
}
