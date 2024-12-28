return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = function(_, opts)
    opts.grep.rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e"
  end,
  keys = {
    -- Override root dir variants with cwd variants
    { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
  },
}
