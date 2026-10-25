-- ============================================================
-- Keymaps
-- ============================================================

local map = vim.keymap.set

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Fast save / quit
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")
map("n", "<leader>Q", "<cmd>q!<cr>")

-- Buffers
map("n", "<leader>n", "<cmd>bnext<cr>")
map("n", "<leader>p", "<cmd>bprev<cr>")
map("n", "<leader>x", "<cmd>bdelete<cr>")

-- Insert escape
map("i", "jk", "<Esc>", { silent = true })

-- Centering
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
