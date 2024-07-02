return {
  "dynamotn/Navigator.nvim",
  keys = {
    { "<c-h>", "<cmd>NavigatorLeft<cr>", { silent = true, desc = "Navigate left" } },
    { "<c-j>", "<cmd>NavigatorDown<cr>", { silent = true, desc = "Navigate down" } },
    { "<c-k>", "<cmd>NavigatorUp<cr>", { silent = true, desc = "Navigate up" } },
    { "<c-l>", "<cmd>NavigatorRight<cr>", { silent = true, desc = "Navigate right" } },
  },
  config = function()
    require("Navigator").setup()
  end,
}
