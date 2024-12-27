-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = function(modes, lhs, rhs, desc)
  if modes == "a" then
    modes = { "v", "n", "i" }
  end
  return vim.keymap.set(modes, lhs, rhs, { desc = desc })
end

map("a", "<Left>", "<nop>")
map("a", "<Right>", "<nop>")
map("a", "<Up>", "<nop>")
map("a", "<Down>", "<nop>")
map("n", "<Leader>uz", "<cmd>ZenMode<cr>", "Enter ZenMode")
map("n", "<leader>bn", ":enew<cr>", "Create new buffer")
map("n", "<leader>gb", "<cmd>BlameToggle<cr>", " Git blame")
map("n", "<c-p>", "<Plug>(YankyPreviousEntry)", "Cycle back in Yanky ring")
map("n", "<c-n>", "<Plug>(YankyNextEntry)", "Cycle forward in Yanky ring")
map("n", "-", "<cmd>Oil<cr>", "Open parent directory in oil")
map("a", "<A-q>", "<cmd>:q<cr>", "Quit Neovim")
map("a", "<leader>r", "<cmd>source<cr>", "Source current file")
map("n", "<A-H>", require("smart-splits").resize_left, "Resize left")
map("n", "<A-J>", require("smart-splits").resize_down, "Resize down")
map("n", "<A-K>", require("smart-splits").resize_up, "Resize up")
map("n", "<A-L>", require("smart-splits").resize_right, "Resize right")
map("n", "<A-h>", require("smart-splits").move_cursor_left, "Move left")
map("n", "<A-k>", require("smart-splits").move_cursor_up, "Move up")
map("n", "<A-l>", require("smart-splits").move_cursor_right, "Move right")
map("n", "<A-\\>", require("smart-splits").move_cursor_previous, "Move previous")
map("v", "<leader>/", function()
  require("fzf-lua").live_grep({
    rg_glob = true,
    no_esc = false,
    rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=512 --multiline",
    search = vim.trim(require("fzf-lua").utils.get_visual_selection()),
  }, "Grep visual selection")
end)

-- Abbreviations
map("ia", "tst", "Test snippet")

-- Abbreviations (Command mode)
map("ca", "tst", "Test command mode snippet")
