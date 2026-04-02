-- ┌────────────────────┐
-- │ MINI configuration │
-- └────────────────────┘
--
-- This file contains configuration of the MINI parts of the config.
-- To minimize the time until first screen draw, modules are enabled in two steps:
-- - Step one enables everything that is needed for first draw with `now()`.
-- - Everything else is delayed until the first draw with `later()`.

-- stylua: ignore start

local now, later = Config.now, Config.later

-- Step one ===================================================================
-- Everything needed for first screen draw. Loaded immediately.

-- Notifications provider. Shows all kinds of notifications in the upper right
-- corner (by default). Example usage:
-- - `:h vim.notify()` - show notification (hides automatically)
-- - `<Leader>xn` - show notification history
now(function()
  require("mini.notify").setup()
  vim.notify = require("mini.notify").make_notify()
end)

-- Tabline that shows listed buffers and tabs on the top line
now(function()
  require("mini.tabline").setup()
end)

-- Statusline that shows mode, git branch, diagnostics, file info
now(function()
  require("mini.statusline").setup()
end)

-- Common configuration presets. Example usage:
-- - `<C-s>` in Insert mode - save and go to Normal mode
-- - `go` / `gO` - insert empty line before/after in Normal mode
-- - `gy` / `gp` - copy / paste from system clipboard
-- - `\` + key - toggle common options. Like `\h` toggles highlighting search.
now(function()
  require("mini.basics").setup({
    autocommands = { relnum_in_visual_mode = true },
  })
end)

-- Icon provider. Usually no need to use manually. It is used by plugins like
-- 'mini.pick', 'mini.files', 'mini.statusline', and others.
now(function()
  require("mini.icons").setup()
  -- Mock 'nvim-tree/nvim-web-devicons' for plugins without 'mini.icons' support
  later(MiniIcons.mock_nvim_web_devicons)
  -- Add LSP kind icons. Useful for 'mini.completion'
  later(MiniIcons.tweak_lsp_kind)
end)

-- Session management. A thin wrapper around `:h mksession` that consistently
-- manages session files. Example usage:
-- - `<Leader>es` - select from saved sessions
now(function()
  require("mini.sessions").setup()
end)

-- Step two: Can be delayed ===================================================

-- Highlight word under cursor throughout the buffer
later(function()
  require("mini.cursorword").setup()
end)

-- Visualize and work with indent scope (like indent object, scope indicator)
later(function()
  require("mini.indentscope").setup({
    draw = {
      delay = 0,
      animation = require("mini.indentscope").gen_animation.none(),
    },
    symbol = "│",
  })
end)

-- Window with buffer text overview and navigation. Example usage:
-- - `<Leader>mc` / `<Leader>mo` - close/open map
-- - `<Leader>mt` - toggle map
later(function()
  require("mini.map").setup()
end)

-- Highlight and remove trailing whitespace. Example usage:
-- - `<Leader>xt` - trim trailing whitespace
later(function()
  require("mini.trailspace").setup()
end)

-- Extra pickers and other functionality for 'mini.nvim' modules
later(function()
  require("mini.extra").setup()
end)

-- Highlight patterns in text (TODO, FIXME, hex colors, etc.)
later(function()
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
end)

-- Extend and create `a`/`i` textobjects (like `a(`, `a)`, `a'`, and more)
-- Works with dot-repeat, `v:count`, different search methods
later(function()
  require("mini.ai").setup()
end)

-- Align text interactively. Example usage:
-- - `ga` in Visual mode or `gaip` - start alignment
later(function()
  require("mini.align").setup()
end)

-- Go forward/backward with square brackets. Example usage:
-- - `]b` / `[b` - next/previous buffer
-- - `]c` / `[c` - next/previous git hunk
-- - `]d` / `[d` - next/previous diagnostic
later(function()
  require("mini.bracketed").setup()
end)

-- Remove buffers without messing up window layout. Example usage:
-- - `<Leader>bd` - delete buffer
-- - `<Leader>bw` - wipeout buffer
later(function()
  require("mini.bufremove").setup()
end)

-- Move visual selection with arrow keys (Karabiner remaps Ctrl+hjkl to arrows)
later(function()
  require("mini.move").setup({
    mappings = {
      left = "<Left>",
      right = "<Right>",
      down = "<Down>",
      up = "<Up>",
      line_left = '',  -- Disabled to prevent conflicts with smart-splits.nvim
      line_right = '',
      line_down = '',
      line_up = '',
    },
  })
end)

-- Show command line and search in a floating window
later(function()
  require("mini.cmdline").setup()
end)

-- Show next key clues for mappings. Example usage:
-- - Press `<Leader>` and wait to see available mappings
-- - Press `g` and wait to see `g` mappings
later(function()
  local miniclue = require("mini.clue")
  miniclue.setup({
    window = {
      config = {},
    },
    triggers = {
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },
      { mode = "x", keys = "[" },
      { mode = "x", keys = "]" },
      { mode = "i", keys = "<C-x>" },
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },
      { mode = "n", keys = "<C-w>" },
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
      { mode = "n", keys = "," },
      { mode = "n", keys = "\\" },
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
end)

-- Comment lines in and out. Example usage:
-- - `gcc` - toggle comment for line
-- - `gc` in Visual mode - toggle comment for selection
later(function()
  require("mini.comment").setup()
end)

-- Code snippets with interactive placeholders. Example usage:
-- - `<Down>` - expand snippet
-- - `<Right>` / `<Left>` - jump to next/previous placeholder
later(function()
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
end)

-- Autocompletion with LSP, snippets, buffer text, and more
-- Custom priority: deprioritize 'Text', put 'Snippet' last
later(function()
  local kind_priority = { Text = -1, Snippet = 99 }
  local opts = { kind_priority = kind_priority }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, opts)
  end

  require("mini.completion").setup({
    window = {
      info = { height = 40, width = 120, border = "rounded" },
      signature = { height = 40, width = 120, border = "rounded" },
    },
    lsp_completion = { source_func = "omnifunc", process_items = process_items },
    fallback_action = nil,
  })
end)

-- Visualize and work with diff hunks. Example usage:
-- - `<Leader>go` - toggle overlay with hunks
later(function()
  require("mini.diff").setup()
end)

-- File explorer in a floating window. Example usage:
-- - `-` - open at current file location
-- - `_` - open at current working directory
later(function()
  local files = require("mini.files")
  files.setup()

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local bufnr = args.data.buf_id

      vim.keymap.set("n", "-", function()
        files.close()
        files.open(vim.api.nvim_buf_get_name(0))
      end, { buffer = bufnr, noremap = true, silent = true })

      vim.keymap.set("n", "_", function()
        files.close()
        files.open()
      end, { buffer = bufnr, noremap = true, silent = true })

      vim.keymap.set("n", "gyp", function()
        local fs_entry = files.get_fs_entry()
        if fs_entry == nil then return end
        vim.fn.setreg("+", fs_entry.path)
        vim.notify("Copied path: " .. fs_entry.path)
      end, { buffer = bufnr, noremap = true, silent = true })

      vim.keymap.set("n", "gx", function()
        local fs_entry = files.get_fs_entry()
        if fs_entry == nil then return end
        vim.fn.system("open " .. vim.fn.shellescape(fs_entry.path))
        vim.notify("Opened: " .. fs_entry.path)
      end, { buffer = bufnr, noremap = true, silent = true })

      vim.keymap.set("n", "cd", function()
        local fs_entry = files.get_fs_entry()
        if fs_entry == nil then return end
        local enclosing = vim.fn.fnamemodify(fs_entry.path, ":h")
        vim.fn.chdir(enclosing)
        vim.notify("Cwd set to " .. enclosing)
      end, { buffer = bufnr, noremap = true, silent = true })

      vim.keymap.set("n", "gt", function()
        local fs_entry = files.get_fs_entry()
        if fs_entry == nil then return end
        local enclosing = vim.fn.fnamemodify(fs_entry.path, ":h")
        local cmd = string.format('wezterm cli spawn --cwd %s', vim.fn.shellescape(enclosing))
        vim.fn.system(cmd)
        vim.notify("Opened terminal in: " .. enclosing)
      end, { buffer = bufnr, noremap = true, silent = true })

      vim.keymap.set("n", "gf", function()
        local fs_entry = files.get_fs_entry()
        if fs_entry == nil then return end
        local cmd = string.format('open -R %s', vim.fn.shellescape(fs_entry.path))
        vim.fn.system(cmd)
        vim.notify("Located in Finder: " .. fs_entry.path)
      end, { buffer = bufnr, noremap = true, silent = true })
    end,
  })
end)

-- Git integration. Example usage:
-- - `<Leader>gs` - show git info at cursor (commit, hunk, etc.)
later(function()
  require("mini.git").setup()
end)

-- Jump to any location with a two-key sequence. Example usage:
-- - `,,` - start jump mode
later(function()
  local jump2d = require("mini.jump2d")
  jump2d.setup({
    spotter = jump2d.gen_spotter.pattern("[^%s%p]+"),
    labels = "asdfjkl",
    view = { dim = true, n_steps_ahead = 2 },
  })
end)

-- Keymap utilities for better keymap definitions
later(function()
  require("mini.keymap").setup()
end)

-- Miscellaneous utilities (zoom, restore cursor position, etc.)
later(function()
  require("mini.misc").setup()
  require("mini.misc").setup_restore_cursor()
end)

-- Text transformation operators. Example usage:
-- - `gXia` - exchange current function argument with next
later(function()
  require("mini.operators").setup({
    exchange = { prefix = "gX" },
  })
end)

-- Fuzzy picker for files, buffers, grep, LSP, git, and more. Example usage:
-- - `<Leader><Leader>` or `<Leader>ff` - pick files
-- - `<Leader>/` or `<Leader>fg` - live grep
-- - `<Leader>fb` - pick buffers
now(function()
  local win_config = function()
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
  require("mini.pick").setup({
    window = {
      config = win_config,
    },
  })
end)

-- Split and join arguments, array items, etc. Example usage:
-- - `gS` - toggle split/join
later(function()
  require("mini.splitjoin").setup()
end)

-- Surround text with brackets, quotes, etc. Example usage:
-- - `sa"` - add double quotes around textobject
-- - `sd"` - delete surrounding double quotes
-- - `sr"'` - replace double quotes with single quotes
later(function()
  require("mini.surround").setup()
end)

-- Track and reuse file visits. Example usage:
-- - `<Leader>vv` / `<Leader>vV` - add/remove "core" label
-- - `<Leader>fv` - pick from all visited files
later(function()
  require("mini.visits").setup()
end)

-- stylua: ignore end
