local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Safely execute immediately ================================================

now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()
end)

now(function() require('mini.tabline').setup() end) -- Top bar
now(function() require('mini.statusline').setup() end) -- Bottom bar
now(function() require('mini.basics').setup({
  mappings = {
    basic = true,
    option_toggle_prefix = [[,]],
  },
  autocommands = { relnum_in_visual_mode = true },
}) end)
now(function() require('mini.colors').setup() end)
now(function() require('mini.cursorword').setup() end)
now(function() require('mini.icons').setup() end)
now(function() require('mini.indentscope').setup() end)
now(function() require('mini.map').setup() end)
now(function() require('mini.sessions').setup() end)
now(function() require('mini.starter').setup() end) -- Shows 'dashboard'
now(function() require('mini.trailspace').setup() end) -- Shows trailing whitespace

-- Safely execute later =======================================================

later(function() require('mini.extra').setup() end)
later(function()
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
later(function() require('mini.ai').setup() end)
later(function() require('mini.align').setup() end)
later(function() require('mini.bracketed').setup() end)
later(function() require('mini.bufremove').setup() end)
later(function()
  local miniclue = require('mini.clue')
  miniclue.setup({
    window = {
      config = {
      },
    },
    triggers = {
      { mode = 'n', keys = '<Leader>' }, -- Leader triggers
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = [[\]] },      -- mini.basics
      { mode = 'n', keys = '[' },        -- mini.bracketed
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' },    -- Built-in completion
      { mode = 'n', keys = 'g' },        -- `g` key
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },        -- Marks
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },        -- Registers
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },    -- Window commands
      { mode = 'n', keys = 'z' },        -- `z` key
      { mode = 'x', keys = 'z' },
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
later(function() require('mini.comment').setup() end)
later(function()
  -- Don't show 'Text' suggestions
  local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
  end
  require('mini.completion').setup({
    lsp_completion = { source_func = 'omnifunc', auto_setup = false, process_items = process_items },
  })

  -- Set up LSP part of completion
  local on_attach = function(args) vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end
  vim.api.nvim_create_autocmd('LspAttach', { callback = on_attach })
  vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })
end)
later(function() require('mini.diff').setup() end)
later(function() require('mini.files').setup() end)
later(function() require('mini.git').setup() end)
later(function()
  local jump2d = require('mini.jump2d')
  jump2d.setup({
    spotter = jump2d.gen_spotter.pattern('[^%s%p]+'),
    labels = 'asdfghjkl',
    view = { dim = true, n_steps_ahead = 2 },
  })
end)
later(function() require('mini.keymap').setup() end)
later(function() require('mini.misc').setup() end)
later(function() require('mini.operators').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.pick').setup({
  mappings = {
      sys_paste = {
        char = "<M-v>",
        func = function()
          MiniPick.set_picker_query({ vim.fn.getreg("+") })
        end,
      },
  }
}) end)
later(function() require('mini.snippets').setup() end)
later(function() require('mini.splitjoin') end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.visits').setup() end)
