local snacks = require("snacks")
-- TODO: Implement these in snacks.picker
return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    layout = {
      fullscreen = true,
    },
    indent = {
      indent = {
        enabled = false,
      },
      chunk = {
        enabled = true,
        char = {
          corner_top = "╭",
          corner_bottom = "╰",
          horizontal = "─",
          vertical = "│",
          arrow = "─",
        },
      },
    },
    dashboard = {
      pane_gap = 5,
      preset = {
        header = table.concat({
          [[   █  █   ]],
          [[   █ ██   ]],
          [[   ████   ]],
          [[   ██ ███   ]],
          [[   █  █   ]],
          [[             ]],
          [[ n e o v i m ]],
        }, "\n"),
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", desc = "New File", action = ":ene | startinsert" },
          { icon = "󱞀 ", desc = "Find Note", action = ":ObsidianSearch" },
          { icon = " ", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", desc = "Projects", action = ":lua Snacks.dashboard.pick('projects')" },
          { icon = "󰊢", desc = "Lazygit", action = ":lua Snacks.lazygit( { cwd = LazyVim.root.git() })" },
          { icon = " ", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = "󰒲 ", desc = "Lazy Extras", action = ":LazyExtras", enabled = package.loaded.lazy ~= nil },
          { icon = " ", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        -- Left pane
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
        -- Right pane
        {
          pane = 2,
          section = "terminal",
          cmd = "colorscript -e hedgehogs | awk '{ print \"  \" $0 }'",
          height = 5,
          padding = 4,
        },
        { pane = 2, section = "projects", icon = " ", title = "Projects", indent = 3, padding = 2 },
        { pane = 2, section = "recent_files", icon = " ", title = "Recent Files", indent = 3, padding = 2 },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local cmds = {
            {
              icon = " ",
              title = "Git Status",
              cmd = "git --no-pager diff --stat -B -M -C || true",
              height = 10,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = in_git,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
      },
    },
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
          regex = false,
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
            ["<a-r>"] = { "toggle_regex", mode = { "n", "i" } },
          },
        },
      },
      actions = {
        ---@param p snacks.Picker
        copy_path_abs = function(p)
          local selected = p:current()
          if selected and selected._path then
            vim.fn.setreg([[*]], selected._path)
          else
            vim.notify("Failed to copy item to clipboard!", vim.log.levels.ERROR)
            Snacks.debug.inspect(selected)
          end
        end,
        ---@param p snacks.Picker
        open_in_finder = function(p)
          local selected = p:current()
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
