local M = {}

---@param path string
---@return string
function M.shorten_path_absolute(path)
  return path:gsub(vim.pesc(vim.fn.expand("$HOME")), "~")
end

---@return string
function M.get_visual_selection()
  local region = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
  P(region)
  return table.concat(region, "\n")
end

return M
