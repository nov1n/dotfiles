return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--smart-case",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--hidden",
        "--glob",
        "!.git",
      },
    },
    pickers = {
      find_files = {
        find_command = { "rg", "--files", "--hidden", "--glob", "!.git" },
      },
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {},
      },
    },
  },
}
