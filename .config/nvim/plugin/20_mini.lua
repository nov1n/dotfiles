-- stylua: ignore start

-- Bootstrap mini.nvim since mini modules load before other plugins
vim.pack.add({ { src = "https://github.com/nvim-mini/mini.nvim" } }, { load = true })

require("mini.notify").setup() -- Enhanced notifications
vim.notify = require("mini.notify").make_notify()
require("mini.tabline").setup() -- Top bar
require("mini.statusline").setup() -- Bottom bar
require("mini.basics").setup({ -- Essential Neovim options and mappings
  autocommands = { relnum_in_visual_mode = true },
})
-- require('mini.colors').setup()
require("mini.cursorword").setup() -- Highlights word under cursor
require("mini.icons").setup() -- File type icons
require("mini.indentscope").setup({ -- Visualizes indent scope
  draw = {
    delay = 0,
    animation = require("mini.indentscope").gen_animation.none(),
  },
  symbol = "│",
})
require("mini.map").setup() -- Minimap for code navigation
require("mini.sessions").setup() -- Session management
-- require('mini.starter').setup()  -- Shows 'dashboard'
require("mini.trailspace").setup() -- Shows trailing whitespace

require("mini.extra").setup() -- Extra functionality for mini modules, e.g. pickers
-- Highlights patterns like TODO, FIXME, hex colors
local hipatterns = require("mini.hipatterns")
local hi_words = MiniExtra.gen_highlighter.words
hipatterns.setup({
  highlighters = {
    fixme = hi_words({ "FIXME" }, "MiniHipatternsFixme"),
    hack = hi_words({ "HACK" }, "MiniHipatternsHack"),
    todo = hi_words({ "TODO" }, "MiniHipatternsTodo"),
    note = hi_words({ "NOTE", "XXX" }, "MiniHipatternsNote"),

    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

require("mini.ai").setup() -- Enhanced text objects
require("mini.align").setup() -- Text alignment
require("mini.bracketed").setup() -- Navigation with [ and ] keys
require("mini.bufremove").setup() -- Better buffer deletion
require("mini.move").setup({
  mappings = {
    -- Mappings are <C-{h,j,k,l}> as Karabiner remaps these to arrow keys.
    -- Move visual selection in Visual mode.
    left = "<Left>",
    right = "<Right>",
    down = "<Down>",
    up = "<Up>",

    -- Move current line in Normal mode
    line_left = "<Left>",
    line_right = "<Right>",
    line_down = "<Down>",
    line_up = "<Up>",
  },
})
-- Shows key binding hints
local miniclue = require("mini.clue")
miniclue.setup({
  window = {
    config = {},
  },
  triggers = {
    { mode = "n", keys = "<Leader>" }, -- Leader triggers
    { mode = "x", keys = "<Leader>" },
    { mode = "n", keys = "[" }, -- mini.bracketed
    { mode = "n", keys = "]" },
    { mode = "x", keys = "[" },
    { mode = "x", keys = "]" },
    { mode = "i", keys = "<C-x>" }, -- Built-in completion
    { mode = "n", keys = "g" }, -- `g` key
    { mode = "x", keys = "g" },
    { mode = "n", keys = "'" }, -- Marks
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },
    { mode = "n", keys = '"' }, -- Registers
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },
    { mode = "n", keys = "<C-w>" }, -- Window commands
    { mode = "n", keys = "z" }, -- `z` key
    { mode = "x", keys = "z" },
    { mode = "n", keys = "," }, -- `,` key
    { mode = "n", keys = "\\" }, -- Toggles
  },
  clues = {
    Config.leader_group_clues,
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.z(),
  },
})
require("mini.comment").setup() -- Smart commenting
-- Code snippets
local snippets = require("mini.snippets")
local config_path = vim.fn.stdpath("config")
snippets.setup({
  snippets = {
    snippets.gen_loader.from_file(config_path .. "/snippets/global.json"),
  },
  mappings = {
    expand = "<Down>",
    jump_next = "<Right>",
    jump_prev = "<Left>",
    stop = "<C-c>",
  },
})

-- Don't show 'Text' suggestions and list snippets last
local kind_priority = { Text = -1, Snippet = 99 }
local opts = { kind_priority = kind_priority }
local process_items = function(items, base)
  return MiniCompletion.default_process_items(items, base, opts)
end

require("mini.completion").setup({
  window = {
    -- The popup menu itself (pum) currently doesn't support a border.
    -- See https://github.com/neovim/neovim/pull/25541 for more details.
    -- TODO: Add rounded border when this PR is merged
    info = { height = 40, width = 120, border = "rounded" },
    signature = { height = 40, width = 120, border = "rounded" },
  },
  lsp_completion = { source_func = "omnifunc", process_items = process_items },
  fallback_action = nil,
})

require("mini.diff").setup() -- Git diff visualization
-- File explorer
local files = require("mini.files")
files.setup()

-- Custom mappings for mini.files
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local bufnr = args.data.buf_id

    -- Make '-' and '_' work normally
    vim.keymap.set("n", "-", function()
      files.close()
      files.open(vim.api.nvim_buf_get_name(0))
    end, { buffer = bufnr, noremap = true, silent = true })

    vim.keymap.set("n", "_", function()
      files.close()
      files.open()
    end, { buffer = bufnr, noremap = true, silent = true })

    -- Copy selected path to system clipboard
    vim.keymap.set("n", "gyp", function()
      local fs_entry = files.get_fs_entry()
      if fs_entry == nil then
        return
      end
      vim.fn.setreg("+", fs_entry.path)
      vim.notify("Copied path: " .. fs_entry.path)
    end, { buffer = bufnr, noremap = true, silent = true })

    -- Open selected file with 'open' command
    vim.keymap.set("n", "gx", function()
      local fs_entry = files.get_fs_entry()
      if fs_entry == nil then
        return
      end
      vim.fn.system("open " .. vim.fn.shellescape(fs_entry.path))
      vim.notify("Opened: " .. fs_entry.path)
    end, { buffer = bufnr, noremap = true, silent = true })

    -- Change cwd to parent directory
    vim.keymap.set("n", "cd", function()
      local fs_entry = files.get_fs_entry()
      if fs_entry == nil then
        return
      end
      local enclosing = vim.fn.fnamemodify(fs_entry.path, ":h")
      vim.fn.chdir(enclosing)
      vim.notify("Cwd set to " .. enclosing)
    end, { buffer = bufnr, noremap = true, silent = true })

    -- Open enclosing directory in new wezterm vertical split
    vim.keymap.set("n", "gt", function()
      local fs_entry = files.get_fs_entry()
      if fs_entry == nil then
        return
      end
      local enclosing = vim.fn.fnamemodify(fs_entry.path, ":h")
      local cmd = string.format(
        'wezterm cli spawn --cwd %s',
        vim.fn.shellescape(enclosing)
      )
      vim.fn.system(cmd)
      vim.notify("Opened terminal in: " .. enclosing)
    end, { buffer = bufnr, noremap = true, silent = true })

    -- Locate item in Finder
    vim.keymap.set("n", "gf", function()
      local fs_entry = files.get_fs_entry()
      if fs_entry == nil then
        return
      end
      local cmd = string.format('open -R %s', vim.fn.shellescape(fs_entry.path))
      vim.fn.system(cmd)
      vim.notify("Located in Finder: " .. fs_entry.path)
    end, { buffer = bufnr, noremap = true, silent = true })
  end,
})

require("mini.git").setup() -- Git integration
-- Jump to any position with 2 keystrokes
-- local jump2d = require("mini.jump2d")
-- jump2d.setup({
--   spotter = jump2d.gen_spotter.pattern("[^%s%p]+"),
--   labels = "asdfghjkl",
--   view = { dim = true, n_steps_ahead = 2 },
-- })

require("mini.keymap").setup() -- Keymap utilities
require("mini.misc").setup()
require("mini.misc").setup_restore_cursor() -- Miscellaneous utilities

require("mini.operators").setup({
  exchange = { prefix = "gX" },
}) -- Text transformation operators
-- require('mini.pairs').setup()     -- Auto-pairs for brackets, quotes
local win_config = function() -- Centers picker window
  local height = math.floor(0.618 * vim.o.lines)
  local width = math.floor(0.618 * vim.o.columns)
  return {
    anchor = "NW",
    height = height,
    width = width,
    row = math.floor(0.5 * (vim.o.lines - height)),
    col = math.floor(0.5 * (vim.o.columns - width)),
  }
end
require("mini.pick").setup({ -- Fuzzy pickers
  window = {
    config = win_config,
  },
})

require("mini.splitjoin").setup() -- Split/join code constructs with gS
require("mini.surround").setup() -- Surround text with pairs
require("mini.visits").setup() -- Track and reuse file visits
-- stylua: ignore end
