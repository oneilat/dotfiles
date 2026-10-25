-- ============================================================
-- Autocommands
-- ============================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Trim trailing whitespace
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Database & SQL specific setup
augroup("DbUIConfig", { clear = true })

-- 1. Setup Completion and UI behavior for SQL files
autocmd("FileType", {
  group = "DbUIConfig",
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    -- Enable dadbod-completion for nvim-cmp
    require("cmp").setup.buffer({
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
    })

    -- Environment Highlighting Logic
    vim.schedule(function()
      local db_name = vim.b.dbui_db_key_name or ""
      if db_name == "PROD" then
        vim.api.nvim_set_hl(0, 'DbuiProdBg', { bg = '#4b0000' })
        vim.wo.winhighlight = "Normal:DbuiProdBg"
      elseif db_name == "QA" then
        vim.api.nvim_set_hl(0, 'DbuiQaBg', { bg = '#2e2e00' })
        vim.wo.winhighlight = "Normal:DbuiQaBg"
      end
    end)
  end,
})

-- 2. Setup "q" to close the DB results window specifically
autocmd("FileType", {
  group = "DbUIConfig",
  pattern = { "dbout" }, -- This is the filetype for query results
  callback = function()
    -- Map 'q' to :q! just for this buffer so you don't get "No write since last change"
    vim.keymap.set("n", "q", "<cmd>q!<cr>", { buffer = true, silent = true })
  end,
})

-- Auto-format on save (LSP-safe)
augroup("AutoFormat", { clear = true })
autocmd("BufWritePre", {
  group = "AutoFormat",
  -- Added "sql" to the pattern list
  pattern = { "*.lua", "*.py", "*.js", "*.ts", "*.jsx", "*.tsx", "*.sql" },
  callback = function()
    vim.lsp.buf.format({
      async = false,
      timeout_ms = 2000,
      filter = function(client)
        -- Ensure the client (like a dedicated SQL LSP or Formatter) supports it
        return client.supports_method("textDocument/formatting")
      end,
    })
  end,
})
