-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = function(modes, lhs, rhs, desc, options)
  local opts = options or {} -- Default options to empty table

  if modes == "_" then
    modes = { "n", "v", "x", "c", "i", "s", "!", "t", "o" }
  end

  -- Add description and silent if not already defined in options
  opts.desc = opts.desc or desc
  opts.silent = opts.silent ~= false and true -- Default to silent unless explicitly set to false
  opts.noremap = opts.noremap ~= false and true -- Default to noremap unless explicitly set to false

  -- Automatically enable expr if rhs is a function, unless explicitly disabled
  if type(rhs) == "function" and opts.expr ~= false then
    opts.expr = true
  end

  return vim.keymap.set(modes, lhs, rhs, opts)
end

-- stylua: ignore start
map("ca",         "__from",     "__to",                                       "Example snippet (command mode)")
map("ia",         "__from",     "__to",                                       "Example snippet (insert mode")
map("n",          "-",          "<cmd>Oil<cr>",                               "Open parent directory in oil")
map({"n", "i"},   "<A-H>",      require("smart-splits").resize_left,          "Resize left")
map({"n", "i"},   "<A-J>",      require("smart-splits").resize_down,          "Resize down")
map({"n", "i"},   "<A-K>",      require("smart-splits").resize_up,            "Resize up")
map({"n", "i"},   "<A-L>",      require("smart-splits").resize_right,         "Resize right")
map({"n", "i"},   "<A-\\>",     require("smart-splits").move_cursor_previous, "Move previous")
map({"n", "i"},   "<A-h>",      require("smart-splits").move_cursor_left,     "Move left")
map({"n", "i"},   "<A-j>",      require("smart-splits").move_cursor_down,     "Move down")
map({"n", "i"},   "<A-k>",      require("smart-splits").move_cursor_up,       "Move up")
map({"n", "i"},   "<A-l>",      require("smart-splits").move_cursor_right,    "Move right")
map("n",          "<leader>do", "<cmd>DiffOrig<cr>",                          "Diff buffer with file on disk")
map("n",          "yp",         ":call setreg('+', expand('%:p'))<cr>",       "Copy filepath")
map("n",          "<leader>bn", ":enew<cr>",                                  "Create new buffer")
map("n",          "<leader>gb", "<cmd>BlameToggle<cr>",                       "Git blame")
map("n",          "<leader>r",  "<cmd>source<cr>",                            "Source current file")
map("n",          "<leader>uz", "<cmd>ZenMode<cr>",                           "Enter ZenMode")
map({"n", "v"},   "<leader>xr", "<cmd>SnipRun<cr>",                           "Run snippet")
map({"n", "t"},   "<C-/>",      "<nop",                                       "Disable terminal keymap")
map({"n", "v"},   "gcb",        "<cmd>CBccbox<cr>",                           "Insert box comment")
map({"n", "v"},   "gct",        "<cmd>CBllline 15<cr>",                       "Insert named parts comment")
map("n",          "gcl",        "<cmd>CBline<cr>",                            "Insert line comment")
map({"n", "v"},   "gcm",        "<cmd>CBllbox10<cr>",                         "Insert a marked comment")
map({"n", "v"},   "gcd",        "<cmd>CBd<cr>",                               "Remove a box comment")
map({"n", "v"},   "<leader>aa", "<cmd>CodeCompanionActions<cr>",              "Show CodeCompanion actions")
map({"n", "v"},   "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>",          "Toggle CodeCompanion chat")
map({"n", "v"},   "<leader>an", "<cmd>CodeCompanionChat<cr>",                 "New CodeCompanion chat")
map({"n", "v"},   "<leader>ap", ":CodeCompanion<cr>",                         "Prompt CodeCompanion")
map("n",          "<leader>fd", function() Snacks.picker.files({cwd = "~/dotfiles"}) end, "Find dotfiles")

map("v",          "<leader>av", "<cmd>CodeCompanionChat Add<cr>",             "Add current selection to CodeCompanion chat")
map({ "n", "x" }, "j", function() return vim.v.count > 1 and "m'" .. vim.v.count .. "j" or "j" end, "Add <count>j to jumplist")
map({ "n", "x" }, "k", function() return vim.v.count > 1 and "m'" .. vim.v.count .. "k" or "k" end, "Add <count>k to jumplist")

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
vim.cmd("nmap <bs> ;") -- HACK: For some reason this mapping works only with vimscript
-- stylua: ignore end
