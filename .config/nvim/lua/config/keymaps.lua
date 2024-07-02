-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("i", "kj", "<ESC>", { desc = "Exit insert mode with kj" })
map("n", "<C-b>", "<cmd>nohl<CR>", { desc = "Clear search highlights with Ctl-B", silent = true })
map("n", "<Leader>uz", "<cmd>ZenMode<CR>", { desc = "Enter ZenMode", silent = true })
map("n", "<leader>bn", ":enew<CR>", { desc = "Create new buffer", noremap = true, silent = true })
map("n", "<C-f>", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Grep in project files" })
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find project files" })

-- Temporary
map("n", "<leader>k", "<cmd>g/I AM NOT DONE/d | w | nohl<CR>", { noremap = true, silent = true })
