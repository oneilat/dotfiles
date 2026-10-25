-- ============================================================
-- Database Management (Dadbod)
-- ============================================================

return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    init = function()
      -- Your connection definitions
      vim.g.dbs = {
        { name = 'DEV',  url = 'postgresql://?service=dev' },
        { name = 'QA',   url = 'postgresql://?service=qa' },
        { name = 'PROD', url = 'postgresql://?service=prod' },
      }

      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_navigation = 1
      vim.g.db_ui_win_width = 35
      vim.g.db_ui_save_location = vim.fn.stdpath("config") .. "/db_queries"

      vim.keymap.set("n", "<leader>du", "<cmd>DBUIToggle<cr>", { desc = "Toggle DB UI" })

      -- 1. Define Highlighting Groups (Colors)
      vim.api.nvim_set_hl(0, 'DbuiProdBg', { bg = '#3d0000' }) -- Deep dark red for PROD
      vim.api.nvim_set_hl(0, 'DbuiQaBg',   { bg = '#2e2e00' }) -- Dark olive for QA

      -- 2. Create the Autocmd to switch backgrounds based on the environment name
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          vim.schedule(function()
            -- b:dbui_db_key_name contains the 'name' from your vim.g.dbs list
            local db_name = vim.b.dbui_db_key_name or ""

            if db_name == "PROD" then
              vim.wo.winhighlight = "Normal:DbuiProdBg"
              print("CONNECTED TO PRODUCTION")
            elseif db_name == "QA" then
              vim.wo.winhighlight = "Normal:DbuiQaBg"
            else
              -- Reset for DEV or others
              vim.wo.winhighlight = ""
            end
          end)
        end,
      })
    end,
  },
}
