-- Define main config table to be able to use it in scripts
_G.Config = {}

-- The rest of the configuration is loaded from plugin/ directory
-- Files are loaded in alphabetical order:
-- - plugin/10_options.lua    - Neovim options and settings
-- - plugin/11_mappings.lua   - Key mappings and leader keys
-- - plugin/12_functions.lua  - Custom functions and utilities
-- - plugin/20_mini.lua       - Mini.nvim plugin configurations
-- - plugin/21_plugins.lua    - Other plugin configurations
