-- stylua: ignore start

-- Leader key =================================================================
vim.g.mapleader = ' '

-- General ====================================================================
vim.o.backup       = false          -- Don't store backup
vim.o.mouse        = 'a'            -- Enable mouse
vim.o.switchbuf    = 'usetab'       -- Use already opened buffers when switching
vim.o.writebackup  = false          -- Don't store backup (better performance)
vim.o.undofile     = true           -- Enable persistent undo
vim.o.swapfile     = false          -- Disable swapfile
vim.opt.autoread   = true           -- Automatically read file when it's modified outside of nvim
vim.o.iskeyword            = '@,48-57,_,192-255,-'                 -- Treat dash separated words as a word text object
vim.o.completeopt          = 'menuone,noselect,fuzzy,nosort'       -- Use fuzzy matching for built-in completion
vim.o.complete             = '.,w,b,kspell'                        -- Use spell check and don't use tags for completion
vim.o.shiftwidth           = 2                                     -- Use this number of spaces for indentation
vim.o.tabstop              = 2                                     -- Insert 2 spaces for a tab
vim.o.autoindent           = true                                  -- Use auto indent
vim.o.expandtab            = true                                  -- Convert tabs to spaces
vim.o.formatoptions        = 'rqnl1j'                              -- Improve comment editing
vim.o.breakindentopt       = 'list:-1'                             -- Add padding for lists when 'wrap' is on
vim.o.completefuzzycollect = 'keyword,files,whole_line'            -- Use fuzzy matching when collecting candidates

-- UI =========================================================================
vim.o.cursorlineopt        = 'screenline,number'                   -- Show cursor line only screen line when wrapped
vim.o.shortmess            = 'CFOSWaco'                            -- Don't show "Scanning..." messages
vim.o.splitkeep            = 'screen'                              -- Reduce scroll during window split
vim.o.winborder            = 'rounded'                             -- Use double-line as default border
vim.o.pumheight            = 10                                    -- Make popup menu smaller
vim.o.winblend             = 10                                    -- Make floating windows slightly transparent
vim.o.pummaxwidth          = 100                                   -- Limit maximum width of popup menu
vim.o.listchars            = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:> ' }, ',') -- Special text symbols
vim.o.fillchars            = table.concat({ 'foldopen:▾', 'foldclose:▸', 'fold: ', 'foldsep: ', 'diff:╱', 'eob: ', }, ',') -- Pretty symbols for folding, diff, and end-of-buffer

 -- LSP autocompletion
vim.o.pumborder = 'rounded'
vim.api.nvim_set_hl(0, 'PmenuBorder', { link = 'FloatBorder' })

-- https://vi.stackexchange.com/questions/24925/usage-of-timeoutlen-and-ttimeoutlen
-- Required to prevent smart-split keybinds from triggering when pressing escape.
-- timeout and timeoutlen apply to mappings.
-- vim.o.timeoutlen = 0
-- ttimeout and ttimeoutlen apply to key codes.
vim.o.ttimeoutlen = 0

-- Command line autocompletion
vim.cmd([[autocmd CmdlineChanged [:/\?@] call wildtrigger()]])
vim.o.wildmode = 'noselect:lastused'
vim.o.wildoptions = 'pum,fuzzy'

-- Editing ====================================================================
vim.o.incsearch      = true      -- Show search results while typing
vim.o.infercase      = true      -- Infer letter cases for a richer built-in keyword completion
vim.o.smartcase      = true      -- Don't ignore case when searching if pattern has upper case
vim.o.smartindent    = true      -- Make indenting smart
vim.o.virtualedit    = 'block'   -- Allow going past the end of line in visual block mode
vim.o.colorcolumn    = '+1'      -- Draw colored column one step to the right of desired maximum width
vim.o.cursorline     = true      -- Enable highlighting of the current line
vim.o.linebreak      = true      -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.list           = true      -- Show helpful character indicators
vim.o.number         = true      -- Show line numbers
vim.o.ruler          = false     -- Don't show cursor position
vim.o.showmode       = false     -- Don't show mode in command line
vim.o.signcolumn     = 'yes'     -- Always show signcolumn or it would frequently shift
vim.o.splitbelow     = true      -- Horizontal splits will be below
vim.o.splitright     = true      -- Vertical splits will be to the right
vim.o.wrap           = false     -- Display long lines as just one line
vim.o.breakindent    = true      -- Indent wrapped lines to match line start
-- stylua: ignore end

-- Define pattern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gw`. This basically reads as 'at
-- least one special character (digit, -, +, *) possibly followed some
-- punctuation (. or `)`) followed by at least one space is a start of list
-- item'
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Custom autocommands ========================================================
local augroup = vim.api.nvim_create_augroup("CustomSettings", {})
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function()
    -- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
    -- If don't do this on `FileType`, this keeps reappearing due to being set in
    -- filetype plugins.
    vim.cmd("setlocal formatoptions-=c formatoptions-=o")
  end,
  desc = [[Ensure proper 'formatoptions']],
})

-- Diagnostics ================================================================
local diagnostic_opts = {
  -- Define how diagnostic entries should be shown
  signs = { priority = 9999, severity = { min = "WARN", max = "ERROR" } },
  underline = { severity = { min = "HINT", max = "ERROR" } },
  virtual_lines = false,
  virtual_text = { current_line = true, severity = { min = "ERROR", max = "ERROR" } },

  -- Don't update diagnostics when typing
  update_in_insert = false,
}
-- stylua: ignore end
