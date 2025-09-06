local Snacks = require("snacks")

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local kb = function(modes_str, lhs, rhs, desc, options)
  local opts = options or {}

  opts.desc = opts.desc or desc
  opts.silent = opts.silent ~= false and true
  opts.noremap = opts.noremap ~= false and true

  local modes = {}
  for i = 1, #modes_str do
    modes[i] = modes_str:sub(i, i)
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
kb("nt", "<m-h>",            require("smart-splits").move_cursor_left,  "Move left")
kb("nt", "<m-j>",            require("smart-splits").move_cursor_down,  "Move down")
kb("nt", "<m-k>",            require("smart-splits").move_cursor_up,    "Move up")
kb("nt", "<m-l>",            require("smart-splits").move_cursor_right, "Move right")
kb("nt", "<m-H>",            require("smart-splits").resize_left,       "Resize left")
kb("nt", "<m-J>",            require("smart-splits").resize_down,       "Resize down")
kb("nt", "<m-K>",            require("smart-splits").resize_up,         "Resize up")
kb("nt", "<m-L>",            require("smart-splits").resize_right,      "Resize right")
kb("n",  "<leader>R",        "<cmd>restart<cr>",                        "Restart Neovim")
kb("n",  "<leader>do",       "<cmd>DiffOrig<cr>",                       "Diff buffer with file on disk")
kb("n",  "<leader>gb",       "<cmd>BlameToggle<cr>",                    "Git blame")
kb("n",  "<leader>gd",       toggle_diffview,                           "Toggle Diffview")
kb("n",  "<leader>r",        "<cmd>source<cr>",                         "Source current file")
kb("n",  "<leader>uz",       "<cmd>ZenMode<cr>",                        "Enter ZenMode")
kb("nv", "<leader>xr",       "<cmd>SnipRun<cr>",                        "Run snippet")
kb("nt", "<c-/>",            "<nop",                                    "Disable terminal keymap")
kb("nv", "gcb",              "<cmd>CBccbox<cr>",                        "Insert box comment")
kb("nv", "gct",              "<cmd>CBllline 15<cr>",                    "Insert named parts comment")
kb("n",  "gcl",              "<cmd>CBline<cr>",                         "Insert line comment")
kb("nv", "gcm",              "<cmd>CBllbox10<cr>",                      "Insert a marked comment")
kb("nv", "gcd",              "<cmd>CBd<cr>",                            "Remove a box comment")
kb("nx", "j",                smart_movement("j"),                       "Add <count>j to jumplist", { expr = true })
kb("nx", "k",                smart_movement("k"),                       "Add <count>k to jumplist", { expr = true })
kb("n",  "-",                function() open_oil_with_preview() end,    "Open parent directory in oil")
kb("n",  "<leader>E",        "<cmd>:LazyExtras<cr>",                    "Open Lazy Extras panel")
kb("n",  "<leader>fp",       project_picker,                            "Find projects")
kb("n",  "<leader>ft",       ":vimgrep /^- / %| copen<cr>",             "Find todos")
kb("ni", "<m-cr>",           vim.lsp.buf.code_action,                   "Perform code action")
kb("n",  "<leader><leader>", "<Nop>",                                   "File picker")
kb("n",  "<leader>/",        "<Nop>",                                   "Grep picker")
kb("c",  "<tab>",            "<Nop>",                                   "Disable tab in command mode")
kb("c",  "<s-tab>",          "<Nop>",                                   "Disable shift tab in command mode")
kb("n",  "s",                "<Nop>",                                   "Disable s key")
-- stylua: ignore end

-- HACK: For some reason this mappings works only with vimscript
vim.cmd('cab w :lua Snacks.notify.error("Disabled")')
vim.cmd('cab q :lua Snacks.notify.error("Disabled")')
vim.cmd('cab wq :lua Snacks.notify.error("Disabled")')
vim.cmd("nmap <bs> ;")
