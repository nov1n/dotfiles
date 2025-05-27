-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- https://vi.stackexchange.com/questions/24925/usage-of-timeoutlen-and-ttimeoutlen
-- Required to prevent smart-split keybinds from triggering when pressing escape.
-- timeout and timeoutlen apply to mappings.
-- vim.o.timeoutlen = 0
-- ttimeout and ttimeoutlen apply to key codes.
vim.o.ttimeoutlen = 0

-- Break lines at word boundaries
vim.opt.linebreak = true

-- Disable all animations from snacks.nvim
vim.g.snacks_animate = false
