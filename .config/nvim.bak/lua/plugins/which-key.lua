return {
  "folke/which-key.nvim",
  event = "VeryLazy", -- Or "BufReadPost" depending on your needs
  opts = {
    spec = {
      { "<leader>o", group = "obsidian", icon = "󱞂" },
      { "<leader>a", group = "opencode", icon = "" },
    },
  },
}
