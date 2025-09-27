-- TODO: read all mini docs and configure where needed, especially mini.pick, mini.files
-- stylua: ignore start
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Safely execute immediately ================================================

now(function()
  require('mini.notify').setup()                        -- Enhanced notifications
  vim.notify = require('mini.notify').make_notify()
end)

now(function() require('mini.tabline').setup() end)     -- Top bar
now(function() require('mini.statusline').setup() end)  -- Bottom bar
now(function() require('mini.basics').setup({           -- Essential Neovim options and mappings
  mappings = {
    basic = true,
    option_toggle_prefix = [[<leader>u]],
  },
  autocommands = { relnum_in_visual_mode = true },
}) end)
-- now(function() require('mini.colors').setup() end)
now(function() require('mini.cursorword').setup() end)  -- Highlights word under cursor
now(function() require('mini.icons').setup() end)       -- File type icons
now(function() require('mini.indentscope').setup({      -- Visualizes indent scope
  draw = {
    delay = 0,
    animation = require('mini.indentscope').gen_animation.none(),
  },
  symbol = '│'
}) end)
now(function() require('mini.map').setup() end)         -- Minimap for code navigation
now(function() require('mini.sessions').setup() end)    -- Session management
-- now(function() require('mini.starter').setup() end)  -- Shows 'dashboard'
now(function() require('mini.trailspace').setup() end)  -- Shows trailing whitespace

-- Safely execute later =======================================================

later(function() require('mini.extra').setup() end)     -- Extra functionality for mini modules, e.g. pickers
later(function()                                        -- Highlights patterns like TODO, FIXME, hex colors
  local hipatterns = require('mini.hipatterns')
  local hi_words = MiniExtra.gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      fixme = hi_words({ 'FIXME' }, 'MiniHipatternsFixme'),
      hack = hi_words({ 'HACK' }, 'MiniHipatternsHack'),
      todo = hi_words({ 'TODO' }, 'MiniHipatternsTodo'),
      note = hi_words({ 'NOTE', 'XXX'}, 'MiniHipatternsNote'),

      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)
later(function() require('mini.ai').setup() end)        -- Enhanced text objects
later(function() require('mini.align').setup() end)     -- Text alignment
later(function() require('mini.bracketed').setup() end) -- Navigation with [ and ] keys
later(function() require('mini.bufremove').setup() end) -- Better buffer deletion
later(function() require('mini.move').setup({
  mappings = {
    -- Mappings are <C-{h,j,k,l}> as Karabiner remaps these to arrow keys.
    -- Move visual selection in Visual mode.
    left = '<Left>',
    right = '<Right>',
    down = '<Down>',
    up = '<Up>',

    -- Move current line in Normal mode
    line_left = '<Left>',
    line_right = '<Right>',
    line_down = '<Down>',
    line_up = '<Up>',
  },
}) end)
later(function()                                        -- Shows key binding hints
  local miniclue = require('mini.clue')
  miniclue.setup({
    window = {
      config = {
      },
    },
    triggers = {
      { mode = 'n', keys = '<Leader>' },                -- Leader triggers
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = '[' },                       -- mini.bracketed
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' },                   -- Built-in completion
      { mode = 'n', keys = 'g' },                       -- `g` key
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },                       -- Marks
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },                       -- Registers
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },                   -- Window commands
      { mode = 'n', keys = 'z' },                       -- `z` key
      { mode = 'x', keys = 'z' },
      { mode = 'n', keys = ',' },                       -- `,` key
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
  }) end)
later(function() require('mini.comment').setup() end)   -- Smart commenting
later(function()                                        -- Code snippets
  local snippets = require('mini.snippets')
  local config_path = vim.fn.stdpath('config')
  snippets.setup({
    snippets = {
      snippets.gen_loader.from_file(config_path .. '/snippets/global.json'),
    },
    mappings = {
      expand = '<Down>',
      jump_next = '<Right>',
      jump_prev = '<Left>',
      stop = '<C-c>',
    },
  })
end)
later(function()
  -- Don't show 'Text' suggestions and list snippets last
  local kind_priority = { Text = -1, Snippet = 99 }
  local opts = { kind_priority = kind_priority }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, opts)
  end

  require('mini.completion').setup({
    window = {
      -- The popup menu itself (pum) currently doesn't support a border.
      -- See https://github.com/neovim/neovim/pull/25541 for more details.
      -- TODO: Add rounded border when this PR is merged
      info = { height = 40, width = 120, border = 'rounded' },
      signature = { height = 40, width = 120, border = 'rounded' },
    },
    lsp_completion = { source_func = 'omnifunc', process_items = process_items },
    fallback_action = nil,
  })
end)
later(function() require('mini.diff').setup() end)      -- Git diff visualization
later(function()                                        -- File explorer
  local files = require('mini.files')
  files.setup()

  -- Custom mappings for mini.files
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local bufnr = args.data.buf_id

      -- Make '-' and '=' work normally
      vim.keymap.set("n", "-", function()
        files.close()
        files.open(vim.api.nvim_buf_get_name(0))
      end, { buffer = bufnr, noremap = true, silent = true })

      vim.keymap.set("n", "=", function()
        files.close()
        files.open()
      end, { buffer = bufnr, noremap = true, silent = true })

      -- Copy selected path to system clipboard
      vim.keymap.set("n", "gyp", function()
        local fs_entry = files.get_fs_entry()
        if fs_entry == nil then return end
        vim.fn.setreg('+', fs_entry.path)
        print("Copied path: " .. fs_entry.path)
      end, { buffer = bufnr, noremap = true, silent = true })

      -- Open selected file with 'open' command
      vim.keymap.set("n", "gx", function()
        local fs_entry = files.get_fs_entry()
        if fs_entry == nil then return end
        vim.fn.system("open " .. vim.fn.shellescape(fs_entry.path))
        print("Opened: " .. fs_entry.path)
      end, { buffer = bufnr, noremap = true, silent = true })

      -- Change cwd to parent directory
      vim.keymap.set("n", "cd", function()
        local fs_entry = files.get_fs_entry()
        if fs_entry == nil then return end
        local enclosing = vim.fn.fnamemodify(fs_entry.path, ":h")
        vim.fn.chdir(enclosing)
        print("Cwd set to " .. enclosing)
      end, { buffer = bufnr, noremap = true, silent = true })
    end,
  })
end)
later(function() require('mini.git').setup() end)       -- Git integration
later(function()                                        -- Jump to any position with 2 keystrokes
  local jump2d = require('mini.jump2d')
  jump2d.setup({
    spotter = jump2d.gen_spotter.pattern('[^%s%p]+'),
    labels = 'asdfghjkl',
    view = { dim = true, n_steps_ahead = 2 },
  })
end)
later(function() require('mini.keymap').setup() end)    -- Keymap utilities
later(function()
  require('mini.misc').setup()
  require('mini.misc').setup_restore_cursor()
end)      -- Miscellaneous utilities
later(function()
  require('mini.operators').setup({
    exchange = { prefix = 'gX' }
  })
end) -- Text transformation operators
-- later(function() require('mini.pairs').setup() end)     -- Auto-pairs for brackets, quotes
local win_config = function()                           -- Centers picker window
  local height = math.floor(0.618 * vim.o.lines)
  local width = math.floor(0.618 * vim.o.columns)
  return {
    anchor = 'NW', height = height, width = width,
    row = math.floor(0.5 * (vim.o.lines - height)),
    col = math.floor(0.5 * (vim.o.columns - width)),
  }
end
later(function() require('mini.pick').setup({           -- Fuzzy pickers
  window = {
    config = win_config
  }
}) end)

later(function() require('mini.splitjoin').setup() end) -- Split/join code constructs with gS
later(function() require('mini.surround').setup() end)  -- Surround text with pairs
later(function() require('mini.visits').setup() end)    -- Track and reuse file visits
-- stylua: ignore end
