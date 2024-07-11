-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("n", "<Leader>uz", "<cmd>ZenMode<CR>", { desc = "Enter ZenMode", silent = true })
map("n", "<leader>bn", ":enew<CR>", { desc = "Create new buffer", noremap = true, silent = true })
map("n", "<leader>.", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find project files" })
map("n", "<leader>/", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Grep in project files" })

-- Temporary
map("n", "<leader>k", "<cmd>g/I AM NOT DONE/d | w | nohl<CR>", { noremap = true, silent = true })
