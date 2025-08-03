return {
  "dmtrKovalenko/fff.nvim",
  build = "cargo build --release",
  opts = {},
  keys = {
    {
      "<leader><leader>", -- try it if you didn't it is a banger keybinding for a picker
      function()
        require("fff").find_files()
      end,
      desc = "FFFind FFFiles",
    },
  },
}
