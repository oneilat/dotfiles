-- ============================================================
-- Core options
-- ============================================================

local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.linebreak = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
opt.undofile = true
opt.swapfile = false
opt.backup = false

-- Clipboard (macOS)
if vim.fn.has("macunix") == 1 then
  opt.clipboard = "unnamedplus"
end

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Statusline (keep minimal for now)
opt.laststatus = 2
opt.statusline = " %f %m %= %l:%c %p%% "
