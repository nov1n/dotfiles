require "nvchad.mappings"
local telescope = require "telescope.builtin"

local map = vim.keymap.set
local abbrev = vim.cmd.cnoreabbrev

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
map("n", "<C-b>", ":nohl<CR>", { desc = "Clear search highlights with Ctl-B" })
map("c", "w!!", "w !sudo tee > /dev/null %", { desc = "Sudo write read-protected file" })

-- Telescope
map("n", "<leader><leader>", telescope.find_files, { desc = "Find files alias" })
map("n", "<leader>fc", telescope.command_history, { desc = "telescope find command history" })

map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

map({ "n", "t" }, "<C-t>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal new horizontal term" })

abbrev("W", "w")
abbrev("WQ", "wq")
abbrev("WQ!", "wq!")
abbrev("Q!", "q!")
