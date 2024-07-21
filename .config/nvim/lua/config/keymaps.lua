-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("n", "<Leader>uz", "<cmd>ZenMode<CR>", { desc = "Enter ZenMode", silent = true })
map("n", "<leader>bn", ":enew<CR>", { desc = "Create new buffer", noremap = true, silent = true })
map("n", "<leader>.", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find project files" })
map("n", "<leader>/", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Grep in project files" })
map("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
map("n", "<c-n>", "<Plug>(YankyNextEntry)")

-- These are triggered by hiasr/vim-zellij-navigator
map("n", "<C-h>", "<CMD>vertical resize +2<CR>")
map("n", "<C-j>", "<CMD>resize +2<CR>")
map("n", "<C-k>", "<CMD>resize -2<CR>")
map("n", "<C-l>", "<CMD>vertical resize -2<CR>")
