-- Bootstrap 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
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

-- Define main config table to be able to use it in scripts
_G.Config = {}

-- The rest of the configuration is loaded from plugin/ directory
-- Files are loaded in alphabetical order:
-- - plugin/10_options.lua    - Neovim options and settings
-- - plugin/11_mappings.lua   - Key mappings and leader keys  
-- - plugin/12_functions.lua  - Custom functions and utilities
-- - plugin/20_mini.lua       - Mini.nvim plugin configurations
-- - plugin/21_plugins.lua    - Other plugin configurations
