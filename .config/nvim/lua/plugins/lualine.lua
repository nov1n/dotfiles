return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Show full relative path
    opts.sections.lualine_c[4] = { "filename", path = 1 }
    -- Replace clock with cwd
    opts.sections.lualine_z = {
      function()
        return " " .. vim.fn.getcwd()
      end,
    }
  end,
}
