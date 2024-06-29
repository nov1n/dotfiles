return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    close_if_last_window = true,
    filesystem = {
      filtered_items = {
        visible = true, -- Don't show hidden files in a lighter color
        hide_dotfiles = false, -- Show dotfiles
      },
    },
  },
}
