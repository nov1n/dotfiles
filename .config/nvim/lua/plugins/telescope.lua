local file_ignore_patterns = {
  -- Files
  "%.class",
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
    defaults = {
      sorting_strategy = "ascending", -- display results top->bottom
      layout_config = {
        prompt_position = "top", -- search bar at the top
      },
    },
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
