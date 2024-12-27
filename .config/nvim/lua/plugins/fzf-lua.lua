return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = function(_, opts)
    opts.grep.rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e"
  end,
}
