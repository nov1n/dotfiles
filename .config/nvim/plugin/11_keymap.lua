-- stylua: ignore start
-- Create global tables with information about clue groups in certain modes
-- Structure of tables is taken to be compatible with 'mini.clue'.
_G.Config.leader_group_clues = {
  { mode = 'n', keys = '<Leader>a', desc = '+AI/OpenCode' },
  { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
  { mode = 'n', keys = '<Leader>u', desc = '+UI Toggles' },
  { mode = 'n', keys = '<Leader>e', desc = '+Explore' },
  { mode = 'n', keys = '<Leader>f', desc = '+Find' },
  { mode = 'n', keys = '<Leader>g', desc = '+Git' },
  { mode = 'n', keys = '\\', desc = '+Toggles' },
  { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
  { mode = 'n', keys = '<Leader>L', desc = '+Lua/Log' },
  { mode = 'n', keys = '<Leader>m', desc = '+Map' },
  { mode = 'n', keys = '<Leader>o', desc = '+Obsidian' },
  { mode = 'n', keys = '<Leader>v', desc = '+Visits' },
  { mode = 'n', keys = '<Leader>x', desc = '+Extra' },
  { mode = 'v', keys = '<Leader>a', desc = '+AI/OpenCode' },
  { mode = 'x', keys = '<Leader>l', desc = '+LSP' },
}

-- Command mode mappings ======================================================

-- Command line autocompletion
vim.keymap.set('c', '<Up>', '<C-u><Up>')
vim.keymap.set('c', '<Down>', '<C-u><Down>')
vim.keymap.set('c', '<Tab>', [[cmdcomplete_info().pum_visible ? "\<C-n>" : "\<Tab>"]], { expr = true })
vim.keymap.set('c', '<S-Tab>', [[cmdcomplete_info().pum_visible ? "\<C-p>" : "\<S-Tab>"]], { expr = true })


-- Insert mode mappings =======================================================

local imap = function(lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('i', lhs, rhs, opts)
end

imap("<Left>", "<Nop>", "Disable left arrow key")
imap("<Right>", "<Nop>", "Disable right arrow key")
imap("<Up>", "<Nop>", "Disable up arrow key")
imap("<Down>", "<Nop>", "Disable down arrow key")

-- Normal mode mappings =======================================================

local nmap = function(lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', lhs, rhs, opts)
end

nmap("<M-h>", function() require("smart-splits").move_cursor_left() end,   "Move left")
nmap("<M-j>", function() require("smart-splits").move_cursor_down() end,   "Move down")
nmap("<M-k>", function() require("smart-splits").move_cursor_up() end,     "Move up")
nmap("<M-l>", function() require("smart-splits").move_cursor_right() end,  "Move right")
nmap("<M-H>", function() require("smart-splits").resize_left() end,        "Resize left")
nmap("<M-J>", function() require("smart-splits").resize_down() end,        "Resize down")
nmap("<M-K>", function() require("smart-splits").resize_up() end,          "Resize up")
nmap("<M-L>", function() require("smart-splits").resize_right() end,       "Resize right")

nmap('-',     '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', 'Files %')
nmap('_',     '<Cmd>lua MiniFiles.open(vim.fn.getcwd())<CR>',              'Files cwd')

-- <Leader> mappings ==========================================================

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
nmap_leader('<leader>', '<Cmd>Pick files<CR>',      'Files')
nmap_leader('/',        '<Cmd>Pick grep_live<CR>',  'Grep live')
nmap_leader(',',        '<Cmd>Pick buffers<CR>',    'Buffers')
nmap_leader('R',        '<Cmd>restart<CR>',         'Restart Neovim')

-- b is for 'buffer'
nmap_leader('ba', '<Cmd>b#<CR>',                                 'Alternate')
nmap_leader('bd', '<Cmd>lua MiniBufremove.delete()<CR>',         'Delete')
nmap_leader('bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>',  'Delete!')
nmap_leader('bn', '<Cmd>enew<CR>',                               'New')
nmap_leader('bs', '<Cmd>lua Config.new_scratch_buffer()<CR>',    'Scratch')
nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>',        'Wipeout')
nmap_leader('bW', '<Cmd>lua MiniBufremove.wipeout(0, true)<CR>', 'Wipeout!')

-- e is for 'explore' and 'edit'
nmap_leader('ec', function()
  require('mini.pick').builtin.files(nil, {
    source = {cwd = vim.fn.stdpath('config')}
  })
end, 'Neovim config files')
nmap_leader('es', '<Cmd>lua MiniSessions.select()<CR>',    'Sessions')

-- \ is for toggles
nmap('\\q', '<Cmd>lua Config.toggle_quickfix()<CR>', 'Toggle Quickfix')
nmap("\\z", '<Cmd>lua MiniMisc.zoom()<CR>', "Toggle zoom")
nmap("\\f", '<Cmd>ZenMode<CR>', "Toggle focus")
nmap("\\t", function()
  require("undotree").open({
    title = "undotree",
    command = "topleft 60vnew",
  })
end, "Toggle undotree")
nmap("\\o", function()
  vim.o.conceallevel = vim.o.conceallevel == 0 and 2 or 0
  vim.notify('conceallevel=' .. vim.o.conceallevel)
end, "Toggle 'conceallevel'")
nmap("\\a", function()
  if vim.g.disable_autoformat then
    vim.cmd("FormatEnable")
    vim.notify("Autoformat enabled")
  else
    vim.cmd("FormatDisable")
    vim.notify("Autoformat disabled")
  end
end, "Toggle autoformat")

-- f is for 'fuzzy find'
nmap_leader('f/', '<Cmd>Pick history scope="search"<CR>',            'Search history')
nmap_leader('f:', '<Cmd>Pick history scope=":"<CR>',                 '":" history')
nmap_leader('fA', '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', 'Added hunks (current)')
nmap_leader('fC', '<Cmd>Pick git_commits path="%"<CR>',              'Commits (current)')
nmap_leader('fD', '<Cmd>Pick diagnostic scope="current"<CR>',        'Diagnostic buffer')
nmap_leader('fG', '<Cmd>Pick grep pattern="<cword>"<CR>',            'Grep current word')
nmap_leader('fH', '<Cmd>Pick hl_groups<CR>',                         'Highlight groups')
nmap_leader('fL', '<Cmd>Pick buf_lines scope="current"<CR>',         'Lines (current)')
nmap_leader('fM', '<Cmd>Pick git_hunks path="%"<CR>',                'Modified hunks (current)')
nmap_leader('fR', '<Cmd>Pick lsp scope="references"<CR>',            'References (LSP)')
nmap_leader('fS', '<Cmd>Pick lsp scope="document_symbol"<CR>',       'Symbols buffer (LSP)')
nmap_leader('fV', '<Cmd>Pick visit_paths<CR>',                       'Visit paths (cwd)')
nmap_leader('fa', '<Cmd>Pick git_hunks scope="staged"<CR>',          'Added hunks (all)')
nmap_leader('fb', '<Cmd>Pick buffers<CR>',                           'Buffers')
nmap_leader('fc', '<Cmd>Pick git_commits<CR>',                       'Commits (all)')
nmap_leader('fd', '<Cmd>Pick diagnostic scope="all"<CR>',            'Diagnostic workspace')
nmap_leader('ff', '<Cmd>Pick files<CR>',                             'Files')
nmap_leader('fg', '<Cmd>Pick grep_live<CR>',                         'Grep live')
nmap_leader('fh', '<Cmd>Pick help<CR>',                              'Help tags')
nmap_leader('fk', '<Cmd>Pick keymaps<CR>',                           'Search keymaps' )
nmap_leader('fl', '<Cmd>Pick buf_lines scope="all"<CR>',             'Lines (all)')
nmap_leader('fm', '<Cmd>Pick git_hunks<CR>',                         'Modified hunks (all)')
nmap_leader('fo', '<Cmd>Pick options<CR>',                           'Search options' )
nmap_leader('fp', '<Cmd>Pick projects<CR>',                          'Projects')
nmap_leader('fr', '<Cmd>Pick resume<CR>',                            'Resume')
nmap_leader('fs', '<Cmd>Pick lsp scope="workspace_symbol"<CR>',      'Symbols workspace (LSP)')
nmap_leader('fv', '<Cmd>Pick visit_paths cwd=""<CR>',                'Visit paths (all)')

-- g is for git
nmap_leader('gb', '<Cmd>let line=line(".")<CR><Cmd>:vert Git blame -- %<CR><Cmd>exe line<CR>', 'Toggle git blame pane')
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
nmap_leader('mp', '<Cmd>LivePreview start<CR>',          'Markdown preview')

-- v is for 'visits'
nmap_leader('vv', '<Cmd>lua MiniVisits.add_label("core")<CR>',                     'Add "core" label')
nmap_leader('vV', '<Cmd>lua MiniVisits.remove_label("core")<CR>',                  'Remove "core" label')
nmap_leader('vl', '<Cmd>lua MiniVisits.add_label()<CR>',                           'Add label')
nmap_leader('vL', '<Cmd>lua MiniVisits.remove_label()<CR>',                        'Remove label')
nmap_leader('vc', '<Cmd>lua MiniVisits.select_path("", { filter = "core" })<CR>',  'Select core (all)')
nmap_leader('vC', '<Cmd>lua MiniVisits.select_path(nil, { filter = "core" })<CR>', 'Select core (cwd)')

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

-- a is for 'AI'
nmap_leader('aA', function() require('opencode').ask(nil, { submit = true }) end,               'Ask opencode')
nmap_leader('aa', function() require('opencode').ask("@this: ", { submit = true }) end,         'Ask opencode about this')
xmap_leader('aa', function() require('opencode').ask('@selection: ', { submit = true }) end,    'Ask opencode about selection')
nmap_leader('ap', function() require("opencode").select() end,                                  'Select prompt')
nmap_leader('ae', function() require('opencode').prompt("Explain @cursor and its context", { submit = true }) end, "Explain code near cursor")
nmap_leader('an', function() require('opencode').command('session_new') end,                    'New session')
nmap_leader('ay', function() require('opencode').command('messages_copy') end,                  'Copy last message')
nmap('<S-C-u>',   function() require('opencode').command('messages_half_page_up') end,          'Scroll messages up')
nmap('<S-C-d>',   function() require('opencode').command('messages_half_page_down') end,        'Scroll messages down')

-- x is for 'extra'
nmap_leader('xh', '<Cmd>normal gxiagxila<CR>',              'Move arg left')
nmap_leader('xl', '<Cmd>normal gxiagxina<CR>',              'Move arg right')
nmap_leader('xS', '<Cmd>lua Config.insert_section()<CR>',   'Section insert')
nmap_leader('xt', '<Cmd>lua MiniTrailspace.trim()<CR>',     'Trim trailspace')
nmap_leader("xn", '<Cmd>lua MiniNotify.show_history()<CR>', 'Show notifications history')

-- Clear search on escape
vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- HACK: For some reason this mapping works only with vimscript
vim.cmd("nmap <bs> ;")
-- stylua: ignore end
