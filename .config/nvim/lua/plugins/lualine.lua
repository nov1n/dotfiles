return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Show full relative path
    opts.sections.lualine_c[4] = { "filename", path = 1 }
    -- Remove the clock component
    opts.sections.lualine_z = {}
  end,
}
