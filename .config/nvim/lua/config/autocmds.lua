-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
-- Define the function to check if the buffer is unnamed and empty, and mark it as not modified
local function close_on_shutdown()
  local bufnr = vim.api.nvim_get_current_buf() -- Get the current buffer number
  local bufname = vim.api.nvim_buf_get_name(bufnr) -- Get the name of the current buffer
  local bufcontent = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false) -- Get the content of the buffer

  -- Check if the buffer is unnamed and empty
  if bufname == "" and #bufcontent == 1 and bufcontent[1] == "" then
    vim.bo[bufnr].modified = false -- Set the buffer as not modified
  end
end

-- Set up an autocommand to call close_on_shutdown on FocusLost
vim.api.nvim_create_autocmd("FocusLost", {
  group = vim.api.nvim_create_augroup("CloseOnShutdownGroup", { clear = true }),
  pattern = "*",
  callback = close_on_shutdown,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "kotlin" },
  desc = "Disable autoformat for kotlin files, because Picnic's style deviates from the default style.",
  callback = function()
    vim.b.autoformat = false
  end,
})

if VARS.notes_dir then
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = VARS.notes_dir .. "/*",
    desc = "Mark 'journal' habit done when saving today's journal entry",
    callback = function()
      local filename = U.get_buf_path()
      local current_date = os.date("%Y%%-%m%%-%d") -- Replace - with %- to turn into a lua pattern
      if string.match(filename, current_date .. ".md$") then
        vim.system({ "habit", "journal" }, {}, function()
          vim.notify("Marked 'journal' habit for today as done.", vim.log.levels.INFO, {
            title = "HabitDeck",
            render = "minimal",
          })
        end)
      end
    end,
  })
end

-- Disable wrapping for text files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "text" },
  callback = function()
    vim.opt_local.wrap = false
  end,
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                      User commands                      │
--          ╰─────────────────────────────────────────────────────────╯
vim.cmd([[command DiffOrig lefta vnew | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis]])
vim.cmd([[command RefreshTodos g/^- /m$]])
