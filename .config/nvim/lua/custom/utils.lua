-- TODO: Add tests to all methods
local M = {}

--- Converts "/home/username/foo" into "~/foo".
---
--- @param path string
function M.shorten_path_absolute(path)
  return path:gsub(vim.pesc(vim.fn.expand("$HOME")), "~")
end

--- Converts "~/foo" into "/home/username/foo"
---
--- @param path string
function M.get_full_path(path)
  return vim.fn.expand(vim.pesc(path))
end

--- Get the full path of a buffer.
---
--- @param bufnr? number Buffer number (defaults to current buffer)
--- @return string Full path of the buffer
function M.get_buf_path(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return vim.api.nvim_buf_get_name(bufnr)
end

--- Get the user's visual selection.
---
--- @return string The visual selection
function M.get_visual_selection()
  local region = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
  return table.concat(region, "\n")
end

return M
