return {
  enabled = false,
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    close_if_last_window = true,
    filesystem = {
      filtered_items = {
        visible = true, -- Don't show hidden files in a lighter color
        hide_dotfiles = false, -- Show dotfiles
      },
      commands = {
        -- Overwrite default 'delete' command to 'trash'.
        delete = function(state)
          local path = state.tree:get_node().path
          local msg = "Are you sure you want to trash " .. path
          require("neo-tree.ui.inputs").confirm(msg, function(confirmed)
            if not confirmed then
              return
            end

            vim.fn.system({ "trash", path })
            require("neo-tree.sources.manager").refresh(state.name)
          end)
        end,

        -- Overwrite default 'delete_visual' command to 'trash' x n.
        delete_visual = function(state, selected_nodes)
          local count = #selected_nodes
          local msg = "Are you sure you want to trash " .. count .. " files?"

          require("neo-tree.ui.inputs").confirm(msg, function(confirmed)
            if not confirmed then
              return
            end

            for _, node in ipairs(selected_nodes) do
              vim.fn.system({ "trash", node.path })
            end

            require("neo-tree.sources.manager").refresh(state.name)
          end)
        end,
      },
    },
  },
}
