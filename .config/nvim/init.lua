-- ============================================================
-- Neovim entry point
-- ============================================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leaders
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Whitespace Fixer
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.sql",
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\%u00a0/ /ge]])
        vim.fn.setpos(".", save_cursor)
    end,
})

-- Core modules
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.diagnostics")

-- Plugins
require("plugins")
