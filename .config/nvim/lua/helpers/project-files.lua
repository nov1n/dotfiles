M = {}

-- Function to check if the current directory is a Git repository
M.is_git_repo = function()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

-- Keybinding function
M.project_files = function()
  local opts = {}
  if M.is_git_repo() then
    require("telescope.builtin").git_files(opts)
  else
    require("telescope.builtin").find_files(opts)
  end
end

return M
