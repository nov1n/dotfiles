-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("i", "kj", "<ESC>", { desc = "Exit insert mode with kj" })
map("n", "<C-b>", ":nohl<CR>", { desc = "Clear search highlights with Ctl-B", silent = true })
map(
  "n",
  "<C-p>",
  "<cmd>lua require('helpers.project-files').project_files()<CR>",
  { noremap = true, silent = true, desc = "Find project files" }
)
