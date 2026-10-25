-- ============================================================
-- Telescope
-- ============================================================

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local map = vim.keymap.set

      local function send_to_qf(prompt_bufnr)
        actions.send_to_qflist(prompt_bufnr)
        actions.open_qflist(prompt_bufnr)
      end

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          file_ignore_patterns = { "node_modules", ".git/", ".DS_Store", "%.venv"},
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = send_to_qf,
            },
            n = {
              ["<C-q>"] = send_to_qf,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
          live_grep = {
            additional_args = function() return { "--hidden" } end,
          },
        },
      })

      pcall(telescope.load_extension, "fzf")

      map("n", "<leader>f", "<cmd>Telescope find_files<cr>")
      map("n", "<leader>g", "<cmd>Telescope live_grep<cr>")
      map("n", "<leader>b", "<cmd>Telescope buffers<cr>")
      map("n", "<leader>r", "<cmd>Telescope oldfiles<cr>")
    end,
  },
}
