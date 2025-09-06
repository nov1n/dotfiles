return {
  "epilande/checkbox-cycle.nvim",
  ft = "markdown",
  opts = {
    states = { "[ ]", "[x]" },
  },
  keys = {
    {
      "<leader>ch",
      "<Cmd>CheckboxCycleNext<CR>",
      desc = "Checkbox Next",
      ft = { "markdown" },
      mode = { "n", "v" },
    },
  },
}
