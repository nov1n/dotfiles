-- TODO:
-- Port useful plugins from my own config
-- Port useful plugins from echan's config
-- configure neodev
-- maybe split out keymaps to a separate file or copy his approach with a few different files
-- stylua: ignore start

-- Bootstrap 'mini.deps =======================================================
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/nvim-mini/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end


-- Set up 'mini.deps' immediately to have its `now()` and `later()` helpers
require('mini.deps').setup()
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Define main config table to be able to use it in scripts
_G.Config = {}

-- Options ====================================================================
vim.g.mapleader            = ' '                                   -- Set leader key to space
vim.o.iskeyword            = '@,48-57,_,192-255,-'                 -- Treat dash separated words as a word text object
vim.o.completeopt          = 'menuone,noselect,fuzzy,nosort'       -- Use fuzzy matching for built-in completion
vim.o.complete             = '.,w,b,kspell'                        -- Use spell check and don't use tags for completion
vim.o.shiftwidth           = 2                                     -- Use this number of spaces for indentation
vim.o.tabstop              = 2                                     -- Insert 2 spaces for a tab
vim.o.autoindent           = true                                  -- Use auto indent
vim.o.expandtab            = true                                  -- Convert tabs to spaces
vim.o.formatoptions        = 'rqnl1j'                              -- Improve comment editing
vim.o.cursorlineopt        = 'screenline,number'                   -- Show cursor line only screen line when wrapped
vim.o.breakindentopt       = 'list:-1'                             -- Add padding for lists when 'wrap' is on
vim.o.shortmess            = 'CFOSWaco'                            -- Don't show "Scanning..." messages
vim.o.splitkeep            = 'screen'                              -- Reduce scroll during window split
vim.o.winborder            = 'rounded'                             -- Use double-line as default border
vim.o.pumheight            = 10                                    -- Make popup menu smaller
vim.o.winblend             = 10                                    -- Make floating windows slightly transparent
vim.o.pummaxwidth          = 100                                   -- Limit maximum width of popup menu
vim.o.completefuzzycollect = 'keyword,files,whole_line'      -- Use fuzzy matching when collecting candidates
vim.o.listchars            = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:> ' }, ',') -- Special text symbols
vim.o.fillchars            = table.concat({ 'foldopen:', 'foldclose:', 'fold: ', 'foldsep: ', 'diff:╱', 'eob: ', }, ',') -- Pretty symbols for folding, diff, and end-of-buffer

-- Command line autocompletion
vim.cmd([[autocmd CmdlineChanged [:/\?@] call wildtrigger()]])
vim.o.wildmode = 'noselect:lastused'
vim.o.wildoptions = 'pum,fuzzy'
vim.keymap.set('c', '<Up>', '<C-u><Up>')
vim.keymap.set('c', '<Down>', '<C-u><Down>')
vim.keymap.set('c', '<Tab>', [[cmdcomplete_info().pum_visible ? "\<C-n>" : "\<Tab>"]], { expr = true })
vim.keymap.set('c', '<S-Tab>', [[cmdcomplete_info().pum_visible ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

-- Mappings ===================================================================

-- Create global tables with information about clue groups in certain modes
-- Structure of tables is taken to be compatible with 'mini.clue'.
_G.Config.leader_group_clues = {
  { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
  { mode = 'n', keys = '<Leader>e', desc = '+Explore' },
  { mode = 'n', keys = '<Leader>f', desc = '+Find' },
  { mode = 'n', keys = '<Leader>g', desc = '+Git' },
  { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
  { mode = 'n', keys = '<Leader>L', desc = '+Lua/Log' },
  { mode = 'n', keys = '<Leader>m', desc = '+Map' },
  { mode = 'n', keys = '<Leader>o', desc = '+Obsidian' },
  { mode = 'n', keys = '<Leader>v', desc = '+Visits' },
  { mode = 'n', keys = '<Leader>x', desc = '+Extra' },
  { mode = 'x', keys = '<Leader>l', desc = '+LSP' },
}

-- From `mini.basics`

-- , for toggling common options:
-- - `b` - |'background'|.
-- - `c` - |'cursorline'|.
-- - `C` - |'cursorcolumn'|.
-- - `d` - diagnostic (via |vim.diagnostic| functions).
-- - `h` - |'hlsearch'| (or |v:hlsearch| to be precise).
-- - `i` - |'ignorecase'|.
-- - `l` - |'list'|.
-- - `n` - |'number'|.
-- - `r` - |'relativenumber'|.
-- - `s` - |'spell'|.
-- - `w` - |'wrap'|.


-- Create normal mode mappings
local nmap = function(lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', lhs, rhs, opts)
end

nmap("<M-h>", function() require("smart-splits").move_cursor_left() end,  "Move left")
nmap("<M-j>", function() require("smart-splits").move_cursor_down() end,  "Move down")
nmap("<M-k>", function() require("smart-splits").move_cursor_up() end,    "Move up")
nmap("<M-l>", function() require("smart-splits").move_cursor_right() end, "Move right")
nmap("<M-H>", function() require("smart-splits").resize_left() end,       "Resize left")
nmap("<M-J>", function() require("smart-splits").resize_down() end,       "Resize down")
nmap("<M-K>", function() require("smart-splits").resize_up() end,         "Resize up")
nmap("<M-L>", function() require("smart-splits").resize_right() end,      "Resize right")

-- Create `<Leader>` mappings
local nmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, opts)
end

local xmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('x', '<Leader>' .. suffix, rhs, opts)
end

-- shortcuts
nmap_leader('<leader>', '<Cmd>Pick files<CR>',                   'Files')
nmap_leader('/',        '<Cmd>Pick grep_live<CR>',               'Grep live')

-- b is for 'buffer'
nmap_leader('ba', '<Cmd>b#<CR>',                                 'Alternate')
nmap_leader('bd', '<Cmd>lua MiniBufremove.delete()<CR>',         'Delete')
nmap_leader('bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>',  'Delete!')
nmap_leader('bs', '<Cmd>lua Config.new_scratch_buffer()<CR>',    'Scratch')
nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>',        'Wipeout')
nmap_leader('bW', '<Cmd>lua MiniBufremove.wipeout(0, true)<CR>', 'Wipeout!')

-- e is for 'explore' and 'edit'
nmap_leader('ec', '<Cmd>edit ~/dotfiles/.config/nvim/init.lua<CR>',            'Neovim config')
nmap_leader('es', '<Cmd>lua MiniSessions.select()<CR>',                        'Sessions')
nmap_leader('eq', '<Cmd>lua Config.toggle_quickfix()<CR>',                     'Quickfix')
nmap_leader('ed', '<Cmd>lua MiniFiles.open()<CR>',                             'Directory')
nmap_leader('ef', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', 'File directory')

-- f is for 'fuzzy find'
nmap_leader('f/', '<Cmd>Pick history scope="search"<CR>',            'Search history')
nmap_leader('f:', '<Cmd>Pick history scope=":"<CR>',                 '":" history')
nmap_leader('fa', '<Cmd>Pick git_hunks scope="staged"<CR>',          'Added hunks (all)')
nmap_leader('fA', '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', 'Added hunks (current)')
nmap_leader('fb', '<Cmd>Pick buffers<CR>',                           'Buffers')
nmap_leader('fc', '<Cmd>Pick git_commits<CR>',                       'Commits (all)')
nmap_leader('fC', '<Cmd>Pick git_commits path="%"<CR>',              'Commits (current)')
nmap_leader('fd', '<Cmd>Pick diagnostic scope="all"<CR>',            'Diagnostic workspace')
nmap_leader('fD', '<Cmd>Pick diagnostic scope="current"<CR>',        'Diagnostic buffer')
nmap_leader('ff', '<Cmd>Pick files<CR>',                             'Files')
nmap_leader('fg', '<Cmd>Pick grep_live<CR>',                         'Grep live')
nmap_leader('fG', '<Cmd>Pick grep pattern="<cword>"<CR>',            'Grep current word')
nmap_leader('fh', '<Cmd>Pick help<CR>',                              'Help tags')
nmap_leader('fH', '<Cmd>Pick hl_groups<CR>',                         'Highlight groups')
nmap_leader('fl', '<Cmd>Pick buf_lines scope="all"<CR>',             'Lines (all)')
nmap_leader('fL', '<Cmd>Pick buf_lines scope="current"<CR>',         'Lines (current)')
nmap_leader('fm', '<Cmd>Pick git_hunks<CR>',                         'Modified hunks (all)')
nmap_leader('fM', '<Cmd>Pick git_hunks path="%"<CR>',                'Modified hunks (current)')
nmap_leader('fr', '<Cmd>Pick resume<CR>',                            'Resume')
nmap_leader('fp', '<Cmd>Pick projects<CR>',                          'Projects')
nmap_leader('fR', '<Cmd>Pick lsp scope="references"<CR>',            'References (LSP)')
nmap_leader('fs', '<Cmd>Pick lsp scope="workspace_symbol"<CR>',      'Symbols workspace (LSP)')
nmap_leader('fS', '<Cmd>Pick lsp scope="document_symbol"<CR>',       'Symbols buffer (LSP)')
nmap_leader('fv', '<Cmd>Pick visit_paths cwd=""<CR>',                'Visit paths (all)')
nmap_leader('fV', '<Cmd>Pick visit_paths<CR>',                       'Visit paths (cwd)')
nmap_leader('fk', '<Cmd>lua Config.pick_keymaps()<CR>',              'Search keymaps' )

-- g is for git
nmap_leader('gb', '<Cmd>BlameToggle<CR>',                   'Toggle git blame')
nmap_leader('gg', '<Cmd>LazyGit<CR>',                       'Open LazyGit')
nmap_leader('go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', 'Toggle overlay')
nmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>',  'Show at cursor')
xmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>',  'Show at selection')

-- l is for 'LSP'
local formatting_cmd = '<Cmd>lua require("conform").format({ lsp_fallback = true })<CR>'
nmap_leader('la', '<Cmd>lua vim.lsp.buf.code_action()<CR>',   'Actions')
nmap_leader('ld', '<Cmd>lua vim.diagnostic.open_float()<CR>', 'Diagnostics popup')
nmap_leader('lR', '<Cmd>lua vim.lsp.buf.references()<CR>',    'References')
nmap_leader('lr', '<Cmd>lua vim.lsp.buf.rename()<CR>',        'Rename')
nmap_leader('ls', '<Cmd>lua vim.lsp.buf.definition()<CR>',    'Source definition')
nmap_leader('lf', formatting_cmd,                             'Format')
xmap_leader('lf', formatting_cmd,                             'Format selection')

-- L is for 'Lua'
nmap_leader('LL', '<Cmd>luafile %<CR><Cmd>echo "Sourced lua"<CR>', 'Source buffer')
nmap_leader('Ls', '<Cmd>lua Config.log_print()<CR>',               'Show log')
nmap_leader('Lx', '<Cmd>lua Config.execute_lua_line()<CR>',        'Execute `lua` line')

-- m is for 'map'
nmap_leader('mc', '<Cmd>lua MiniMap.close()<CR>',        'Close')
nmap_leader('mf', '<Cmd>lua MiniMap.toggle_focus()<CR>', 'Focus (toggle)')
nmap_leader('mo', '<Cmd>lua MiniMap.open()<CR>',         'Open')
nmap_leader('mr', '<Cmd>lua MiniMap.refresh()<CR>',      'Refresh')
nmap_leader('ms', '<Cmd>lua MiniMap.toggle_side()<CR>',  'Side (toggle)')
nmap_leader('mt', '<Cmd>lua MiniMap.toggle()<CR>',       'Toggle')

-- v is for 'visits'
nmap_leader('vv', '<Cmd>lua MiniVisits.add_label("core")<CR>',    'Add "core" label')
nmap_leader('vV', '<Cmd>lua MiniVisits.remove_label("core")<CR>', 'Remove "core" label')
nmap_leader('vl', '<Cmd>lua MiniVisits.add_label()<CR>',          'Add label')
nmap_leader('vL', '<Cmd>lua MiniVisits.remove_label()<CR>',       'Remove label')

-- o is for 'obsidian'
nmap_leader("o/",  "<cmd>ObsidianSearch<CR>",         "Search notes in vault")
nmap_leader("ob",  "<cmd>ObsidianBacklinks<CR>",      "Backlinks for current buffer")
nmap_leader("oc",  "<cmd>ObsidianToggleCheckbox<CR>", "Cycle checkbox state")
nmap_leader("of",  "<cmd>ObsidianFollowLink<CR>",     "Follow note reference")
nmap_leader("oja", "<cmd>ObsidianDailies<CR>",        "Open list of daily notes")
nmap_leader("ojt", "<cmd>ObsidianToday<CR>",          "Open today's note")
nmap_leader("ojn", "<cmd>ObsidianTomorrow<CR>",       "Open tomorrow's note")
nmap_leader("ojp", "<cmd>ObsidianYesterday<CR>",      "Open yesterday's note")
nmap_leader("on",  "<cmd>ObsidianNew<CR>",            "Create a new note")
nmap_leader("oo",  "<cmd>ObsidianOpen<CR>",           "Open Obsidian")
nmap_leader("op",  "<cmd>ObsidianPasteImg<CR>",       "Paste clipboard image")
nmap_leader("or",  "<cmd>ObsidianRename<CR>",         "Rename current note")
nmap_leader("ol",  "<cmd>ObsidianTemplate<CR>",       "Insert a template")
nmap_leader("ot",  "<cmd>ObsidianTags<CR>",           "List notes by tag")

-- x is for 'extra'
nmap_leader('xh', '<Cmd>normal gxiagxila<CR>',              'Move arg left')
nmap_leader('xg', '<Cmd>lua MiniDoc.generate()<CR>',        'Generate plugin doc')
nmap_leader('xl', '<Cmd>normal gxiagxina<CR>',              'Move arg right')
nmap_leader('xS', '<Cmd>lua Config.insert_section()<CR>',   'Section insert')
nmap_leader('xt', '<Cmd>lua MiniTrailspace.trim()<CR>',     'Trim trailspace')
nmap_leader('xz', '<Cmd>lua MiniMisc.zoom()<CR>',           'Zoom toggle')
nmap_leader("xn", '<Cmd>lua MiniNotify.show_history()<CR>', 'Show notifications history')

-- HACK: For some reason this mapping works only with vimscript
vim.cmd("nmap <bs> ;")

-- Functions ==================================================================

-- Create listed scratch buffer and focus on it
Config.new_scratch_buffer = function() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end

-- Fuzzy find keymaps
Config.pick_keymaps = function()
  local key_modes = { "n", "i", "c", "v", "t" }
  local entries = {}
  
  local function add_keymap(keymap)
    -- ignore dummy mappings
    if type(keymap.rhs) == "string" and #keymap.rhs == 0 then
      return
    end

    -- ignore <SNR> and <Plug> mappings by default
    if type(keymap.lhs) == "string" then
      local lhs = vim.trim(keymap.lhs:lower())
      if lhs:match("<snr>") or lhs:match("<plug>") then
        return
      end
    end

    local display = string.format("%-1s │ %-20s │ %s",
      keymap.mode,
      keymap.lhs:gsub("%s", "<Space>"),
      keymap.desc or keymap.rhs or tostring(keymap.callback or ""))

    table.insert(entries, { text = display })
  end

  for _, mode in pairs(key_modes) do
    local global = vim.api.nvim_get_keymap(mode)
    for _, keymap in pairs(global) do
      add_keymap(keymap)
    end
    local buf_local = vim.api.nvim_buf_get_keymap(0, mode)
    for _, keymap in pairs(buf_local) do
      add_keymap(keymap)
    end
  end

  -- sort alphabetically
  table.sort(entries, function(a, b) return a.text < b.text end)

  local pick = require('mini.pick')
  pick.start({
    source = {
      items = entries,
      name = "Keymaps",
    },
  })
end

-- Insert section
Config.insert_section = function(symbol, total_width)
  symbol = symbol or '='
  total_width = total_width or 79

  -- Insert template: 'commentstring' but with '%s' replaced by section symbols
  local comment_string = vim.bo.commentstring
  local content = string.rep(symbol, total_width - (comment_string:len() - 2))
  local section_template = comment_string:format(content)
  vim.fn.append(vim.fn.line('.'), section_template)

  -- Enable Replace mode in appropriate place
  local inner_start = comment_string:find('%%s')
  vim.fn.cursor(vim.fn.line('.') + 1, inner_start)
  vim.cmd([[startreplace]])
end

-- Execute current line with `lua`
Config.execute_lua_line = function()
  local line = 'lua ' .. vim.api.nvim_get_current_line()
  vim.api.nvim_command(line)
  print(line)
  vim.api.nvim_input('<Down>')
end

Config.toggle_quickfix = function()
  local cur_tabnr = vim.fn.tabpagenr()
  for _, wininfo in ipairs(vim.fn.getwininfo()) do
    if wininfo.quickfix == 1 and wininfo.tabnr == cur_tabnr then return vim.cmd('cclose') end
  end
  vim.cmd('copen')
end

-- Plugins ====================================================================

-- Safely execute immediately
now(function()
  add({ source = 'folke/tokyonight.nvim', })
  vim.cmd('colorscheme tokyonight')
end)
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

-- Tree-sitter (advanced syntax parsing, highlighting, textobjects)
later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  add({ source = 'nvim-treesitter/nvim-treesitter-textobjects' })

  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      "bash",
      "hcl",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "terraform",
      "yaml",
      'bash',
      'c',
      'cpp',
      'css',
      'diff',
      'go',
      'html',
      'javascript',
      'json',
      'julia',
      'nu',
      'php',
      'python',
      'r',
      'regex',
      'rst',
      'rust',
      'toml',
      'tsx',
      'yaml',
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    textobjects = { select = { enable = true } },
  }
end)

-- Install LSP/formatting/linter executables
later(function()
  add('mason-org/mason.nvim')
  require('mason').setup()
end)

later(function()
  add('neovim/nvim-lspconfig')

  -- All language servers are expected to be installed with 'mason.nvim'
  vim.lsp.enable({
    'lua_ls',
    'rust_analyzer',
    'ts_ls',
  })
end)

later(function()
  add({
    source = 'folke/lazydev.nvim',
    depends = {
      'nvim-lua/plenary.nvim',
      'gonstoll/wezterm-types',
    },
  })

  require('lazydev').setup({
    library = {
      { path = 'wezterm-types', mods = { 'wezterm' } },
    },
  })
end)


-- Formatting =================================================================
later(function()
  add('stevearc/conform.nvim')

  require('conform').setup({
    -- Map of filetype to formatters
    formatters_by_ft = {
      javascript = { 'prettier' },
      sh = { 'shfmt' },
      json = { 'prettier' },
      lua = { 'stylua' },
      python = { 'black' },
    },

    formatters = {
      shfmt = {
        prepend_args = { "-i", "2", "-ci" },
      },
      prettier = {
        prepend_args = { "--prose-wrap=always" },
      },
    },
  })
end)

later(function()
  add({
    source = 'epwalsh/obsidian.nvim',
    depends = {
      'nvim-lua/plenary.nvim',
    },
  })

  require('obsidian').setup({
    daily_notes = {
      folder = 'Journal',
      default_tags = { 'journal' },
    },
    templates = {
      folder = 'Templates',
      date_format = '%Y-%m-%d-%a',
      time_format = '%H:%M',
      substitutions = {
        yesterday = function()
          return os.date('%Y-%m-%d', os.time() - 86400)
        end,
      },
    },
    workspaces = {
      {
        name = 'personal',
        path = '~/Notes',
      },
    },
    picker = {
      name = 'mini.pick',
    },
  })
end)

later(function()
  add({ source = 'kdheepak/lazygit.nvim'})
end)
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
later(function() require('mini.extra').setup() end)
later(function() require('mini.files').setup() end)
later(function() require('mini.git').setup() end)
-- later(function() require('mini.jump').setup() end)
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
-- TODO: I think this is nice, but keybinds currently conflict with smart-splits
-- later(function() require('mini.move').setup() end)
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
later(function()
  add({
    source = 'FabijanZulj/blame.nvim'
  })
  require('blame').setup()
end)
later(function()
  add({
    source = 'mrjones2014/smart-splits.nvim'
  })
end)
later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    -- Perform action after every checkout
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  -- Possible to immediately execute code which depends on the added plugin
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vimdoc' },
    highlight = { enable = true },
  })
end)

-- Custom autocommands ========================================================
local augroup = vim.api.nvim_create_augroup('CustomSettings', {})
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  callback = function()
    -- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
    -- If don't do this on `FileType`, this keeps reappearing due to being set in
    -- filetype plugins.
    vim.cmd('setlocal formatoptions-=c formatoptions-=o')
  end,
  desc = [[Ensure proper 'formatoptions']],
})

-- Diagnostics
local diagnostic_opts = {
  -- Define how diagnostic entries should be shown
  signs = { priority = 9999, severity = { min = 'WARN', max = 'ERROR' } },
  underline = { severity = { min = 'HINT', max = 'ERROR' } },
  virtual_lines = false,
  virtual_text = { current_line = true, severity = { min = 'ERROR', max = 'ERROR' } },

  -- Don't update diagnostics when typing
  update_in_insert = false,
}

-- Use `later()` to avoid sourcing `vim.diagnostic` on startup
later(function() vim.diagnostic.config(diagnostic_opts) end)

-- stylua: ignore end
