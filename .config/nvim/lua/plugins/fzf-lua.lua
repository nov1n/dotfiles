return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = {
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
