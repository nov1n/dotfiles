return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      natural_order = true,
      is_always_hidden = function(name, _)
        return name == ".." or name == ".git"
      end,
    },
    float = {
      padding = 2,
      max_width = 90,
      max_height = 0,
    },
    win_options = {
      wrap = true,
      winblend = 0,
    },
    keymaps = {
      ["<C-c>"] = false,
      ["<C-s>"] = "<Cmd>w<CR><Esc>",
      ["q"] = "actions.close",
    },
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
}
