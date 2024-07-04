return {
  "monaqa/dial.nvim",
  recommended = true,
  desc = "Increment and decrement numbers, dates, and more",
  -- stylua: ignore
  keys = {
    { "+", "<cmd>DialIncrement<CR>", desc = "Increment", mode = { "n", "v" } },
    { "-", "<cmd>DialDecrement<CR>", desc = "Decrement", mode = { "n", "v" } },
  },
}
