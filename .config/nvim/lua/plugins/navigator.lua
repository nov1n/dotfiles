return {
  -- TODO: Use main repo once https://github.com/numToStr/Navigator.nvim/pull/35 is merged.
  "dynamotn/Navigator.nvim",
  config = function()
    require("Navigator").setup()
  end,
}
