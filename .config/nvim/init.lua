_G.U = require("custom/utils")
require("custom.globals")
require("custom.clipboard").init()

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Experimental automatic session restoration
-- HACK: This autocmd doesn't work when put into the autocmds.lua and I don't know why.
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("Persistence", { clear = true }),
  callback = function()
    -- NOTE: Before restoring the session, check:
    -- 1. No arg passed when opening nvim, means no `nvim --some-arg ./some-path`
    -- 2. No pipe, e.g. `echo "Hello world" | nvim`
    if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
      require("persistence").load()
    end
  end,
  -- HACK: need to enable `nested` otherwise the current buffer will not have a filetype (no syntax)
  nested = true,
})
