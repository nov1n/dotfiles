-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = function(modes, lhs, rhs, desc)
  if modes == "a" then
    modes = { "v", "n", "i" }
  end
  return vim.keymap.set(modes, lhs, rhs, { desc = desc })
end

local function search_visual_selection()
  require("fzf-lua").live_grep({
    rg_glob = true,
    no_esc = false,
    rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=512 --multiline",
    search = vim.trim(U.get_visual_selection()),
  })
end

-- stylua: ignore start
map("a",          "<down>",     "<nop>",                                      "Disable down arrow")
map("a",          "<left>",     "<nop>",                                      "Disable left arrow")
map("a",          "<right>",    "<nop>",                                      "Disable right arrow")
map("a",          "<up>",       "<nop>",                                      "Disable up arrow")
map("ca",         "__from",     "__to",                                       "Example snippet (command mode)")
map("ia",         "__from",     "__to",                                       "Example snippet (insert mode")
map("n",          "-",          "<cmd>Oil<cr>",                               "Open parent directory in oil")
map("n",          "<A-H>",      require("smart-splits").resize_left,          "Resize left")
map("n",          "<A-J>",      require("smart-splits").resize_down,          "Resize down")
map("n",          "<A-K>",      require("smart-splits").resize_up,            "Resize up")
map("n",          "<A-L>",      require("smart-splits").resize_right,         "Resize right")
map("n",          "<A-\\>",     require("smart-splits").move_cursor_previous, "Move previous")
map("n",          "<A-h>",      require("smart-splits").move_cursor_left,     "Move left")
map("n",          "<A-j>",      require("smart-splits").move_cursor_down,     "Move down")
map("n",          "<A-k>",      require("smart-splits").move_cursor_up,       "Move up")
map("n",          "<A-l>",      require("smart-splits").move_cursor_right,    "Move right")
map("n",          "<c-n>",      "<Plug>(YankyNextEntry)",                     "Cycle forward in Yanky ring")
map("n",          "<c-p>",      "<Plug>(YankyPreviousEntry)",                 "Cycle back in Yanky ring")
map("n",          "<leader>fd", "<cmd>DiffOrig<cr>",                          "Diff buffer with file on disk")
map("i",          "<S-Enter>",  "<Esc>A;<CR>",                                "Shift enter adds semicolon to end of line")
map("n",          "yp", ":call setreg('+', expand('%:p'))<CR>",               "Copy filepath")
map("n",          "<leader>bn", ":enew<cr>",                                  "Create new buffer")
map("n",          "<leader>gb", "<cmd>BlameToggle<cr>",                       "Git blame")
map("n",          "<leader>r",  "<cmd>source<cr>",                            "Source current file")
map("n",          "<leader>uz", "<cmd>ZenMode<cr>",                           "Enter ZenMode")
map("v",          "<leader>/",  search_visual_selection,                      "Grep visual selection")
map({ "n", "v" }, "<leader>xr", "<cmd>SnipRun<cr>",                           "Run snippet")
map({"n", "t"},   "<C-/>",      "<nop",                                       "Disable terminal keymap")

--          ╭─────────────────────────────────────────────────────────╮
--          │                       Comment Box                       │
--          ╰─────────────────────────────────────────────────────────╯
map({ "n", "v" }, "gcb", "<Cmd>CBccbox<CR>", "Insert box comment")
map({ "n", "v" }, "gct", "<Cmd>CBllline 15<CR>", "Insert named parts comment")
map("n",          "gcl", "<Cmd>CBline<CR>", "Insert line comment")
map({ "n", "v" }, "gcm", "<Cmd>CBllbox10<CR>", "Insert a marked comment")
map({ "n", "v" }, "gcd", "<Cmd>CBd<CR>", "Remove a box comment")
-- HACK: For some reason this mapping works only with vimscript
vim.cmd("nmap <bs> ;")
-- stylua: ignore end
