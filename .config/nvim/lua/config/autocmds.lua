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
    vim.api.nvim_buf_set_option(bufnr, "modified", false) -- Set the buffer as not modified
  end
end

-- Set up an autocommand to call close_on_shutdown on FocusLost
vim.api.nvim_create_autocmd("FocusLost", {
  group = vim.api.nvim_create_augroup("CloseOnShutdownGroup", { clear = true }),
  pattern = "*",
  callback = close_on_shutdown,
})
