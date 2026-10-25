-- ============================================================
-- UI / UX plugins
-- ============================================================

return {

  -- Dashboard
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        "                                         ",
        "   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                         ",
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "🔍  Find Files", "<cmd>Telescope find_files<cr>"),
        dashboard.button("g", "🔎  Live Grep", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("d", "🗄️  Databases", "<cmd>%bd|DBUI<cr>"),
        dashboard.button("r", "📁  Recent Files", "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("b", "📋  Buffers", "<cmd>Telescope buffers<cr>"),
        dashboard.button("c", "⚙️   Config", "<cmd>Telescope find_files cwd=~/.config/nvim<cr>"),
        dashboard.button("q", "🚪  Quit", "<cmd>qa<cr>"),
      }

      dashboard.section.footer.val = "⚡ Ready to code on macOS"

      alpha.setup(dashboard.config)
    end,
  },

  -- Colorscheme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope = { enabled = false },
      })
    end,
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
    end,
  },
}
