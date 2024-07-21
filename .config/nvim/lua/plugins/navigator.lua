-- return {
--   -- TODO: Use main repo once https://github.com/numToStr/Navigator.nvim/pull/35 is merged.
--   "dynamotn/Navigator.nvim",
--   config = function()
--     require("Navigator").setup()
--   end,
-- }

return {
  "https://git.sr.ht/~swaits/zellij-nav.nvim",
  lazy = true,
  event = "VeryLazy",
  keys = {
    { "<A-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "navigate left" } },
    { "<A-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" } },
    { "<A-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" } },
    { "<A-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
  },
  opts = {},
}
