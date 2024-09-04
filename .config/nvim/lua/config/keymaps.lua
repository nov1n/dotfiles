-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("n", "<Leader>uz", "<cmd>ZenMode<CR>", { desc = "Enter ZenMode", silent = true })
map("n", "<leader>bn", ":enew<CR>", { desc = "Create new buffer", noremap = true, silent = true })
map("n", "<leader>gb", "<cmd>BlameToggle<CR>", { noremap = true, silent = true, desc = "Git blame" })
map("n", "<leader>.", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find project files" })
map("n", "<leader>/", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Grep in project files" })
map("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
map("n", "<c-n>", "<Plug>(YankyNextEntry)")

-- Navigation
map("n", "<A-H>", require("smart-splits").resize_left)
map("n", "<A-J>", require("smart-splits").resize_down)
map("n", "<A-K>", require("smart-splits").resize_up)
map("n", "<A-L>", require("smart-splits").resize_right)

map("n", "<A-h>", require("smart-splits").move_cursor_left)
map("n", "<A-j>", require("smart-splits").move_cursor_down)
map("n", "<A-k>", require("smart-splits").move_cursor_up)
map("n", "<A-l>", require("smart-splits").move_cursor_right)
map("n", "<A-\\>", require("smart-splits").move_cursor_previous)
