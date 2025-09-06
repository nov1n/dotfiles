return {
  "michaelb/sniprun",
  branch = "master",
  build = "sh install.sh 1",
  config = function()
    require("sniprun").setup({
      -- your options
    })
  end,
}
