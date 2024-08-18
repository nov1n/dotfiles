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

vim.keymap.set("n", "<A-H>", require("smart-splits").resize_left)
vim.keymap.set("n", "<A-J>", require("smart-splits").resize_down)
vim.keymap.set("n", "<A-K>", require("smart-splits").resize_up)
vim.keymap.set("n", "<A-L>", require("smart-splits").resize_right)

vim.keymap.set("n", "<A-h>", require("smart-splits").move_cursor_left)
vim.keymap.set("n", "<A-j>", require("smart-splits").move_cursor_down)
vim.keymap.set("n", "<A-k>", require("smart-splits").move_cursor_up)
vim.keymap.set("n", "<A-l>", require("smart-splits").move_cursor_right)
vim.keymap.set("n", "<A-\\>", require("smart-splits").move_cursor_previous)
