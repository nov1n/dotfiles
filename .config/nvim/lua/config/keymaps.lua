local Snacks = require("snacks")

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = function(modes, lhs, rhs, desc, options)
  local opts = options or {}

  opts.desc = opts.desc or desc
  opts.silent = opts.silent ~= false and true
  opts.noremap = opts.noremap ~= false and true

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

local open_oil_with_preview = function()
  local oil = require("oil")
  oil.open(nil, { preview = {} }, function()
    vim.api.nvim_command("vertical resize 40")
  end)
end

local toggle_diffview = function()
  local diffview = require("diffview.lib")
  local view = diffview.get_current_view()
  if view then
    vim.cmd("DiffviewClose")
  else
    vim.fn.feedkeys(":DiffviewOpen ")
  end
end

-- WARNING: Incorrect use of '{ expr = true }' will cause the keybind to lazily
-- evaluate every time it's pressed causing UI lag, use with caution.
local function smart_movement(direction)
  return function()
    return vim.v.count > 1 and "m'" .. vim.v.count .. direction or direction
  end
end

-- stylua: ignore start
map({ "n", "t" },   "<m-h>",            require("smart-splits").move_cursor_left,   "Move left")
map({ "n", "t" },   "<m-j>",            require("smart-splits").move_cursor_down,   "Move down")
map({ "n", "t" },   "<m-k>",            require("smart-splits").move_cursor_up,     "Move up")
map({ "n", "t" },   "<m-l>",            require("smart-splits").move_cursor_right,  "Move right")
map({ "n", "t" },   "<m-H>",            require("smart-splits").resize_left,        "Resize left")
map({ "n", "t" },   "<m-J>",            require("smart-splits").resize_down,        "Resize down")
map({ "n", "t" },   "<m-K>",            require("smart-splits").resize_up,          "Resize up")
map({ "n", "t" },   "<m-L>",            require("smart-splits").resize_right,       "Resize right")
map({ "n" },        "<leader>R",        "<cmd>restart<cr>",                         "Restart Neovim")
map({ "n" },        "<leader>do",       "<cmd>DiffOrig<cr>",                        "Diff buffer with file on disk")
map({ "n" },        "<leader>bn",       ":enew<cr>",                                "Create new buffer")
map({ "n" },        "<leader>gb",       "<cmd>BlameToggle<cr>",                     "Git blame")
map({ "n" },        "<leader>gd",       toggle_diffview,                            "Toggle Diffview")
map({ "n" },        "<leader>r",        "<cmd>source<cr>",                          "Source current file")
map({ "n" },        "<leader>uz",       "<cmd>ZenMode<cr>",                         "Enter ZenMode")
map({ "n", "v" },   "<leader>xr",       "<cmd>SnipRun<cr>",                         "Run snippet")
map({ "n", "t" },   "<c-/>",            "<nop",                                     "Disable terminal keymap")
map({ "n", "v" },   "gcb",              "<cmd>CBccbox<cr>",                         "Insert box comment")
map({ "n", "v" },   "gct",              "<cmd>CBllline 15<cr>",                     "Insert named parts comment")
map({ "n" },        "gcl",              "<cmd>CBline<cr>",                          "Insert line comment")
map({ "n", "v" },   "gcm",              "<cmd>CBllbox10<cr>",                       "Insert a marked comment")
map({ "n", "v" },   "gcd",              "<cmd>CBd<cr>",                             "Remove a box comment")
map({ "n", "x" },   "j",                smart_movement("j"),                        "Add <count>j to jumplist", { expr = true })
map({ "n", "x" },   "k",                smart_movement("k"),                        "Add <count>k to jumplist", { expr = true })
map({ "n" },        "-",                function() open_oil_with_preview() end,     "Open parent directory in oil")
map({ "n" },        "<leader>E",        "<cmd>:LazyExtras<cr>",                     "Open Lazy Extras panel")
map({ "n" },        "<leader>fp",       project_picker,                             "Find projects")
map({ "n" },        "<leader>ft",       ":vimgrep /^- / %| copen<cr>",              "Find todos")
map({ "n", "i" },   "<m-cr>",           vim.lsp.buf.code_action,                    "Perform code action")
map({ "n" },        "<leader><leader>", function() Snacks.picker.files() end,       "Smart find files")
map({ "c" },        "<tab>",            "<Nop>",                                    "Disable tab in command mode")
map({ "c" },        "<s-tab>",          "<Nop>",                                    "Disable shift tab in command mode")
map({ "n" },        "s",                "<Nop>",                                    "Disable s key")
-- stylua: ignore end

-- HACK: For some reason this mappings works only with vimscript
vim.cmd('cab w :lua Snacks.notify.error("Disabled")')
vim.cmd('cab q :lua Snacks.notify.error("Disabled")')
vim.cmd('cab wq :lua Snacks.notify.error("Disabled")')
vim.cmd("nmap <bs> ;")
