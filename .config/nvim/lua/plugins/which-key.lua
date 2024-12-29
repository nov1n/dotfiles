return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    preset = "helix",
    defaults = {},
    spec = {
      { "<leader>a", group = "avante", icon = { icon = "󰙵 ", color = "cyan" } },
      { "<leader>o", group = "obsidian", icon = { icon = "󰙵 ", color = "black" } },
    },
  },
}
