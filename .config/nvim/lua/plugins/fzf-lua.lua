local path = require("fzf-lua.path")

local function open_in_finder(selected, opts)
  for _, sel in ipairs(selected) do
    local entry = path.entry_to_file(sel, opts, opts._uri)
    if entry.path == "<none>" then
      return
    end
    local fullpath = entry.bufname or entry.uri and entry.uri:match("^%a+://(.*)") or entry.path
    local resolved = vim.fn.fnamemodify(fullpath, ":p")

    -- Open in Finder
    vim.fn.jobstart({ "open", "-R", resolved }, { detach = true })
  end
  vim.api.nvim_win_close(0, true)
end

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = {
    defaults = { formatter = "path.filename_first" },
    files = {
      actions = {
        ["alt-o"] = { open_in_finder },
      },
    },
    grep = {
      -- Default rg opts with added  --hidden flag
      rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
    },
    previewers = {
      builtin = {
        extensions = {
          -- Neovim terminal only supports `viu` block output.
          -- Unfortunately this means blurry output until neovim supports kitty graphics protocol.
          -- see https://github.com/ibhagwan/fzf-lua/issues/26#issuecomment-1066503752
          ["png"] = { "viu", "-b" },
          ["jpg"] = { "viu", "-b" },
        },
      },
    },
  },

  keys = {
    -- Override root dir variants with cwd variants
    { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
  },
}
