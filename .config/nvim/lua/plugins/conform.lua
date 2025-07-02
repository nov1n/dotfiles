return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2", "-ci" },
      },
      prettier = {
        prepend_args = { "--prose-wrap=always" },
      },
    },
  },
}
