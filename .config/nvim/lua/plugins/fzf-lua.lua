local path = require("fzf-lua.path")

-- Converts an entry to an absolute path
local function path_from_entry(entry, opts)
  local file = path.entry_to_file(entry, opts, opts._uri)
  local fullpath = file.bufname or file.uri and file.uri:match("^%a+://(.*)") or file.path
  local resolved = vim.fn.fnamemodify(fullpath, ":p")
  return resolved
end

-- Opens all selected entries in Finder
local function open_in_finder(selected, opts)
  for _, entry in ipairs(selected) do
    vim.fn.jobstart({ "open", "-R", path_from_entry(entry, opts) }, { detach = true })
  end
  vim.api.nvim_win_close(0, true)
end

-- Copies the path of the firs selected entry to the clipboard
local function copy_path(selected, opts)
  for _, entry in ipairs(selected) do
    vim.fn.setreg([[*]], path_from_entry(entry, opts))
    vim.api.nvim_win_close(0, true)
    return
  end
end

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = {
    defaults = { formatter = "path.filename_first" },
    files = {
      actions = {
        ["ctrl-o"] = { open_in_finder },
        ["ctrl-y"] = { copy_path },
      },
    },
    grep = {
      -- Default rg opts with added  --hidden flag
      rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
    },
    winopts = {
      fullscreen = true,
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
