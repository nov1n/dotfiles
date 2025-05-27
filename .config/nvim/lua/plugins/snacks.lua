-- TODO: Implement these in snacks.picker
return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    dashboard = { enabled = false },
    picker = {
      sources = {
        files = {
          hidden = true,
        },
        explorer = {
          hidden = true,
        },
        buffers = {
          hidden = true,
        },
        grep = {
          hidden = true,
        },
        todo_comments = {
          hidden = true,
        },
      },
      formatters = {
        file = {
          filename_first = true,
        },
      },
      matcher = {
        frecency = true,
      },
      win = {
        input = {
          keys = {
            ["<C-y>"] = { "copy_path_abs", mode = { "n", "i" } },
            ["<C-o>"] = { "open_in_finder", mode = { "n", "i" } },
          },
        },
      },
      actions = {
        copy_path_abs = function(picker)
          local selected = picker:current()
          if selected and selected._path then
            vim.fn.setreg([[*]], selected._path)
          else
            vim.notify("Failed to copy item to clipboard!", vim.log.levels.ERROR)
            Snacks.debug.inspect(selected)
          end
        end,
        open_in_finder = function(picker)
          local selected = picker:current()
          if selected and selected._path then
            os.execute("open -R " .. vim.fn.shellescape(selected._path))
          else
            vim.notify("Failed to open in Finder!", vim.log.levels.ERROR)
            Snacks.debug.inspect(selected)
          end
        end,
      },
    },
  },
}
