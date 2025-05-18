return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Show full relative path
    opts.sections.lualine_c[4] = { "filename", path = 1 }
    -- Disable clock
    opts.sections.lualine_z = {}
    -- Add cwd to right side
    opts.sections.lualine_x = {
      function()
        return " " .. vim.fn.getcwd()
      end,
    }
  end,
}
