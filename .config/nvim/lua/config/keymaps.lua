local Snacks = require("snacks")

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = function(modes, lhs, rhs, desc, options)
  local opts = options or {} -- Default options to empty table

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

local project_picker = function()
  Snacks.picker.projects({
    dev = { "~/Projects/personal", "~/Projects/picnic" },
    projects = { "~/dotfiles" },
    recent = false,
    win = {
      preview = { minimal = true },
      input = {
        keys = {
          ["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
        },
      },
    },
  })
end

-- stylua: ignore start
--                                 HACK: The vim.schedule was needed, because the plugin stopped working at some point. Figure out why.
map({ "n" },        "<M-h>",      function() vim.schedule(require("smart-splits").move_cursor_left) end,       "Move left")
map({ "n" },        "<M-j>",      function() vim.schedule(require("smart-splits").move_cursor_down) end,       "Move down")
map({ "n" },        "<M-k>",      function() vim.schedule(require("smart-splits").move_cursor_up) end,         "Move up")
map({ "n" },        "<M-l>",      function() vim.schedule(require("smart-splits").move_cursor_right) end,      "Move right")
map({ "n" },        "<M-H>",      function() vim.schedule(require("smart-splits").resize_left) end,            "Resize left")
map({ "n" },        "<M-J>",      function() vim.schedule(require("smart-splits").resize_down) end,            "Resize down")
map({ "n" },        "<M-K>",      function() vim.schedule(require("smart-splits").resize_up) end,              "Resize up")
map({ "n" },        "<M-L>",      function() vim.schedule(require("smart-splits").resize_right) end,           "Resize right")
map({ "n" },        "<leader>do", "<cmd>DiffOrig<cr>",                                                         "Diff buffer with file on disk")
map({ "n" },        "yp",         ":call setreg('+',                                                           expand('%:p'))<cr>", "Copy filepath")
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
map({ "n", "v" },   "<leader>aa", "<cmd>CodeCompanionActions<cr>",                                             "Show CodeCompanion actions")
map({ "n", "v" },   "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>",                                         "Toggle CodeCompanion chat")
map({ "n", "v" },   "<leader>an", "<cmd>CodeCompanionChat<cr>",                                                "New CodeCompanion chat")
map({ "n", "v" },   "<leader>ap", ":CodeCompanion<cr>",                                                        "Prompt CodeCompanion")
map({ "v" },        "<leader>av", "<cmd>CodeCompanionChat Add<cr>",                                            "Add current selection to CodeCompanion chat")
map({ "n", "x" },   "j",          function() return vim.v.count > 1 and "m'" .. vim.v.count .. "j" or "j" end, "Add <count>j to jumplist")
map({ "n", "x" },   "k",          function() return vim.v.count > 1 and "m'" .. vim.v.count .. "k" or "k" end, "Add <count>k to jumplist")
map({ "n" },        "-",          "<cmd>Oil<cr>",                                                              "Open parent directory in oil")
map({ "n" },        "<leader>E",  "<cmd>:LazyExtras<cr>",                                                      "Open Lazy Extras panel")
map({ "n" },        "<leader>fd", function() Snacks.picker.files({cwd = "~/dotfiles"}) end,                    "Find dotfiles")
map({ "n" },        "<leader>fp", project_picker,                                                              "Find projects")
map({ "n", "i" },   "<M-cr>",     vim.lsp.buf.code_action,                                                     "Perform code action")
map({"n"},          "<leader>fs", function() Snacks.picker.smart() end,                                        "Smart Find Files")
-- stylua: ignore end
--
-- HACK: For some reason this mappings works only with vimscript
vim.cmd("cab cc CodeCompanion")
vim.cmd('cab w :lua Snacks.notify.error("Disabled")')
vim.cmd('cab q :lua Snacks.notify.error("Disabled")')
vim.cmd('cab wq :lua Snacks.notify.error("Disabled")')
vim.cmd("nmap <bs> ;")
