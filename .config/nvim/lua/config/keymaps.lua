local Snacks = require("snacks")

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = function(modes, lhs, rhs, desc, options)
  local opts = options or {} -- Default options to empty table

  opts.desc = opts.desc or desc -- Add description and silent if not already defined in options
  opts.silent = opts.silent ~= false and true -- Default to silent unless explicitly set to false
  opts.noremap = opts.noremap ~= false and true -- Default to noremap unless explicitly set to false

  return vim.keymap.set(modes, lhs, rhs, opts)
end

local project_picker = function()
  Snacks.picker.projects({
    dev = { "~/Projects/personal", "~/Projects/picnic" },
    projects = { "~/dotfiles" },
    recent = false,
    win = {
      preview = { minimal = true },
      input = {
        keys = {
          ["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "Delete word" },
        },
      },
    },
  })
end

-- stylua: ignore start
map({ "n" },        "<M-h>",      require("smart-splits").move_cursor_left,                                    "Move left")
map({ "n" },        "<M-j>",      require("smart-splits").move_cursor_down,                                    "Move down")
map({ "n" },        "<M-k>",      require("smart-splits").move_cursor_up,                                      "Move up")
map({ "n" },        "<M-l>",      require("smart-splits").move_cursor_right,                                   "Move right")
map({ "n" },        "<M-H>",      require("smart-splits").resize_left,                                         "Resize left")
map({ "n" },        "<M-J>",      require("smart-splits").resize_down,                                         "Resize down")
map({ "n" },        "<M-K>",      require("smart-splits").resize_up,                                           "Resize up")
map({ "n" },        "<M-L>",      require("smart-splits").resize_right,                                        "Resize right")
map({ "n" },        "<leader>do", "<cmd>DiffOrig<cr>",                                                         "Diff buffer with file on disk")
map({ "n" },        "<leader>bn", ":enew<cr>",                                                                 "Create new buffer")
map({ "n" },        "<leader>gb", "<cmd>BlameToggle<cr>",                                                      "Git blame")
map({ "n" },        "<leader>r",  "<cmd>source<cr>",                                                           "Source current file")
map({ "n" },        "<leader>uz", "<cmd>ZenMode<cr>",                                                          "Enter ZenMode")
map({ "n", "v" },   "<leader>xr", "<cmd>SnipRun<cr>",                                                          "Run snippet")
map({ "n", "t" },   "<C-/>",      "<nop",                                                                      "Disable terminal keymap")
map({ "n", "v" },   "gcb",        "<cmd>CBccbox<cr>",                                                          "Insert box comment")
map({ "n", "v" },   "gct",        "<cmd>CBllline 15<cr>",                                                      "Insert named parts comment")
map({ "n" },        "gcl",        "<cmd>CBline<cr>",                                                           "Insert line comment")
map({ "n", "v" },   "gcm",        "<cmd>CBllbox10<cr>",                                                        "Insert a marked comment")
map({ "n", "v" },   "gcd",        "<cmd>CBd<cr>",                                                              "Remove a box comment")
-- WARNING: Incorrect use of '{ expr = true }' will cause the keybind to lazily evaluate every time it's pressed causing UI lag, use with caution.
map({ "n", "x" },   "j",          function() return vim.v.count > 1 and "m'" .. vim.v.count .. "j" or "j" end, "Add <count>j to jumplist", { expr = true })
map({ "n", "x" },   "k",          function() return vim.v.count > 1 and "m'" .. vim.v.count .. "k" or "k" end, "Add <count>k to jumplist", { expr = true })
map({ "n" },        "-",          "<cmd>Oil<cr>",                                                              "Open parent directory in oil")
map({ "n" },        "<leader>E",  "<cmd>:LazyExtras<cr>",                                                      "Open Lazy Extras panel")
map({ "n" },        "<leader>fp", project_picker,                                                              "Find projects")
map({ "n" },        "<leader>ft", ":vimgrep /^- / %| copen<cr>",                                               "Find todos")
map({ "n", "i" },   "<M-cr>",     vim.lsp.buf.code_action,                                                     "Perform code action")
map({ "n" },        "<leader>fd", function() Snacks.picker.files({cwd = "~/dotfiles"}) end,                    "Find dotfiles")
map({"n"},          "<leader>fs", function() Snacks.picker.smart() end,                                        "Smart find files")
-- stylua: ignore end

-- HACK: For some reason this mappings works only with vimscript
vim.cmd('cab w :lua Snacks.notify.error("Disabled")')
vim.cmd('cab q :lua Snacks.notify.error("Disabled")')
vim.cmd('cab wq :lua Snacks.notify.error("Disabled")')
vim.cmd("nmap <bs> ;")
