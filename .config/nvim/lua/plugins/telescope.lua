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
        additional_args = function(_)
          return { "--hidden" }
        end,
      },
    },
  },
}
