require "nvchad.mappings"

local telescope = require "telescope.builtin"

local map = vim.keymap.set
local abbrev = vim.cmd.cnoreabbrev

map("i", "jk", "<ESC>")
map("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
map("n", "<C-b>", ":nohl<CR>", { desc = "Clear search highlights with Ctl-B", silent = true })

-- Telescope
map("n", "<leader><leader>", telescope.find_files, { desc = "Find files alias" })
map("n", "<leader>fc", telescope.command_history, { desc = "telescope find command history" })
map("n", "<leader>fs", telescope.lsp_dynamic_workspace_symbols, { desc = "telescope find workspace symbols" })
map("n", "<leader>fk", telescope.keymaps, { desc = "telescope find keymaps" })

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Terminal
map({ "n", "t" }, "<C-t>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal new horizontal term" })

-- Autocorrect
abbrev("W", "w")
abbrev("WQ", "wq")
abbrev("WQ!", "wq!")
abbrev("Q!", "q!")

-- Disable escape
map({ "n", "i", "v", "c" }, "<Esc>", "<Nop>", { noremap = true, silent = true })

-- Overwrite Lazy's pane navigation mappings in favor of tmux-navigator's
-- See https://github.com/LazyVim/LazyVim/discussions/277.
map({ "i", "n", "v" }, "<C-k>", "<cmd>TmuxNavigateUp<cr><esc>", { desc = "Move cursor to top pane" })
map({ "i", "n", "v" }, "<C-j>", "<cmd>TmuxNavigateDown<cr><esc>", { desc = "Move cursor to bottom pane" })
map({ "i", "n", "v" }, "<C-h>", "<cmd>TmuxNavigateLeft<cr><esc>", { desc = "Move cursor to left pane" })
map({ "i", "n", "v" }, "<C-l>", "<cmd>TmuxNavigateRight<cr><esc>", { desc = "Move cursor to right pane" })
map({ "i", "n", "v" }, "<C-\\>", "<cmd>TmuxNavigatePrevious<cr><esc>", { desc = "Move cursor to previous pane" })
