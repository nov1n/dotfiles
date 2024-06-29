local file_ignore_patterns = {
  -- Files
  "%.a",
  "%.class",
  "%.mkv",
  "%.mp4",
  "%.o",
  "%.out",
  "%.pdf",
  "%.zip",
  "%.lock",
  "%.lock.json",
  -- Directories
  ".cache",
  ".git/",
  ".github/",
  ".node_modules/",
}

return {
  "nvim-telescope/telescope.nvim",
  opts = {
    pickers = {
      live_grep = {
        file_ignore_patterns = file_ignore_patterns,
        additional_args = function(_)
          return { "--hidden" }
        end,
      },
      find_files = {
        file_ignore_patterns = file_ignore_patterns,
        hidden = true,
      },
    },
  },
}
