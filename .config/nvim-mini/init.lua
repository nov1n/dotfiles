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
vim.g.mapleader = ' '                               -- Set leader key to space
vim.o.iskeyword   = '@,48-57,_,192-255,-'           -- Treat dash separated words as a word text object
vim.o.completeopt = 'menuone,noselect,fuzzy,nosort' -- Use fuzzy matching for built-in completion
vim.o.complete    = '.,w,b,kspell'                  -- Use spell check and don't use tags for completion
vim.o.tabstop     = 2                               -- Insert 2 spaces for a tab

-- Mappings ===================================================================
-- Create global tables with information about clue groups in certain modes
-- Structure of tables is taken to be compatible with 'mini.clue'.
_G.Config.leader_group_clues = {
  { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
  { mode = 'n', keys = '<Leader>e', desc = '+Explore' },
  { mode = 'n', keys = '<Leader>f', desc = '+Find' },
  { mode = 'n', keys = '<Leader>g', desc = '+Git' },
  { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
  { zbqr = 'a', xrlf = '<Yrnqre>Y', qrfp = '+Yhn/Ybt' },
  { zbqr = 'a', xrlf = '<Yrnqre>z', qrfp = '+Znc' },
  { mode = 'n', keys = '<Leader>o', desc = '+Other' },
  { mode = 'n', keys = '<Leader>v', desc = '+Visits' },

  { mode = 'x', keys = '<Leader>l', desc = '+LSP' },
  { mode = 'x', keys = '<Leader>r', desc = '+R' },
}

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

-- Clear hl on <esc>
vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

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

-- shortcuts of longer commands
nmap_leader('<leader>', '<Cmd>Pick files<CR>',                             'Files')
nmap_leader('/', '<Cmd>Pick grep_live<CR>',                         'Grep live')

-- b is for 'buffer'
nmap_leader('ba', '<Cmd>b#<CR>',                                 'Alternate')
nmap_leader('bd', '<Cmd>lua MiniBufremove.delete()<CR>',         'Delete')
nmap_leader('bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>',  'Delete!')
nmap_leader('bs', '<Cmd>lua Config.new_scratch_buffer()<CR>',    'Scratch')
nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>',        'Wipeout')
nmap_leader('bW', '<Cmd>lua MiniBufremove.wipeout(0, true)<CR>', 'Wipeout!')

-- e is for 'explore' and 'edit'
nmap_leader('ec', '<Cmd>edit ~/dotfiles/.config/nvim/init.lua<CR>', 'Neovim config')
nmap_leader('es', '<Cmd>lua MiniSessions.select()<CR>',             'Sessions')
nmap_leader('eq', '<Cmd>lua Config.toggle_quickfix()<CR>',          'Quickfix')
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

-- g is for git
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
nmap_leader('ga', '<Cmd>Git diff --cached<CR>',                   'Added diff')
nmap_leader('gA', '<Cmd>Git diff --cached -- %<CR>',              'Added diff buffer')
nmap_leader('gc', '<Cmd>Git commit<CR>',                          'Commit')
nmap_leader('gC', '<Cmd>Git commit --amend<CR>',                  'Commit amend')
nmap_leader('gd', '<Cmd>Git diff<CR>',                            'Diff')
nmap_leader('gD', '<Cmd>Git diff -- %<CR>',                       'Diff buffer')
nmap_leader('gg', '<Cmd>lua Config.open_lazygit()<CR>',           'Git tab')
nmap_leader('gl', '<Cmd>' .. git_log_cmd .. '<CR>',               'Log')
nmap_leader('gL', '<Cmd>' .. git_log_cmd .. ' --follow -- %<CR>', 'Log buffer')
nmap_leader('go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>',       'Toggle overlay')
nmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>',        'Show at cursor')
xmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>',        'Show at selection')

-- l is for 'LSP' (Language Server Protocol)
local formatting_cmd = '<Cmd>lua require("conform").format({ lsp_fallback = true })<CR>'
nmap_leader('la', '<Cmd>lua vim.lsp.buf.code_action()<CR>',   'Actions')
nmap_leader('ld', '<Cmd>lua vim.diagnostic.open_float()<CR>', 'Diagnostics popup')
nmap_leader('li', '<Cmd>lua vim.lsp.buf.hover()<CR>',         'Information')
nmap_leader('lj', '<Cmd>lua vim.diagnostic.goto_next()<CR>',  'Next diagnostic')
nmap_leader('lk', '<Cmd>lua vim.diagnostic.goto_prev()<CR>',  'Prev diagnostic')
nmap_leader('lR', '<Cmd>lua vim.lsp.buf.references()<CR>',    'References')
nmap_leader('lr', '<Cmd>lua vim.lsp.buf.rename()<CR>',        'Rename')
nmap_leader('ls', '<Cmd>lua vim.lsp.buf.definition()<CR>',    'Source definition')
nmap_leader('lf', formatting_cmd,                             'Format')
xmap_leader('lf', formatting_cmd,                             'Format selection')

-- L is for 'Lua'
nmap_leader('Lc', '<Cmd>lua Config.log_clear()<CR>',               'Clear log')
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

-- o is for 'other'
local trailspace_toggle_command = '<Cmd>lua vim.b.minitrailspace_disable = not vim.b.minitrailspace_disable<CR>'
nmap_leader('oC', '<Cmd>lua MiniCursorword.toggle()<CR>',  'Cursor word hl toggle')
nmap_leader('oh', '<Cmd>normal gxiagxila<CR>',             'Move arg left')
nmap_leader('oH', '<Cmd>TSBufToggle highlight<CR>',        'Highlight toggle')
nmap_leader('og', '<Cmd>lua MiniDoc.generate()<CR>',       'Generate plugin doc')
nmap_leader('ol', '<Cmd>normal gxiagxina<CR>',             'Move arg right')
nmap_leader('or', '<Cmd>lua MiniMisc.resize_window()<CR>', 'Resize to default width')
nmap_leader('oS', '<Cmd>lua Config.insert_section()<CR>',  'Section insert')
nmap_leader('ot', '<Cmd>lua MiniTrailspace.trim()<CR>',    'Trim trailspace')
nmap_leader('oT', trailspace_toggle_command,               'Trailspace hl toggle')
nmap_leader('oz', '<Cmd>lua MiniMisc.zoom()<CR>',          'Zoom toggle')

-- Create insert mode mappings
local imap = function(lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('i', lhs, rhs, opts)
end

-- Create listed scratch buffer and focus on it
Config.new_scratch_buffer = function() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end

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

-- Tabpage with lazygit
Config.open_lazygit = function()
  vim.cmd('tabedit')
  vim.cmd('setlocal nonumber signcolumn=no')

  -- Unset vim environment variables to be able to call `vim` without errors
  -- Use custom `--git-dir` and `--work-tree` to be able to open inside
  -- symlinked submodules
  vim.fn.termopen('VIMRUNTIME= VIM= lazygit --git-dir=$(git rev-parse --git-dir) --work-tree=$(realpath .)', {
    on_exit = function()
      vim.cmd('silent! :checktime')
      vim.cmd('silent! :bw')
    end,
  })
  vim.cmd('startinsert')
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
-- now(function() require('mini.tabline').setup() end)
-- now(function() require('mini.statusline').setup() end)
now(function() require('mini.basics').setup() end)
now(function() require('mini.colors').setup() end)
now(function() require('mini.cursorword').setup() end)
now(function() require('mini.hipatterns').setup() end)
now(function() require('mini.icons').setup() end)
now(function() require('mini.indentscope').setup() end)
now(function() require('mini.map').setup() end)

now(function() require('mini.sessions').setup() end)
now(function() require('mini.starter').setup() end)
now(function() require('mini.trailspace').setup() end)

-- Safely execute later
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
later(function() require('mini.completion').setup() end)
later(function() require('mini.diff').setup() end)
later(function() require('mini.extra').setup() end)
later(function() require('mini.files').setup() end)
later(function() require('mini.git').setup() end)
-- later(function() require('mini.jump').setup() end)
later(function()
  local jump2d = require('mini.jump2d')
  jump2d.setup({
    spotter = jump2d.gen_spotter.pattern('[^%s%p]+'),
    labels = 'asdfghjkl;',
    view = { dim = true, n_steps_ahead = 2 },
  })
  vim.keymap.set({ 'n', 'x', 'o' }, 'sj', function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end)
end)
later(function() require('mini.keymap').setup() end)
later(function() require('mini.misc').setup() end)
-- TODO: I think this is nice, but keybinds currently conflict with smart-splits
-- later(function() require('mini.move').setup() end)
later(function() require('mini.operators').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.pick').setup() end)

later(function() require('mini.snippets').setup() end)
later(function() require('mini.splitjoin') end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.visits').setup() end)
later(function()
  add({
    source = 'mrjones2014/smart-splits.nvim'
  })
end)

now(function()
  -- Use other plugins with `add()`. It ensures plugin is available in current
  -- session (installs if absent)
  add({
    source = 'neovim/nvim-lspconfig',
    -- Supply dependencies near target plugin
    depends = { 'williamboman/mason.nvim' },
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
