return {
  "L3MON4D3/LuaSnip",
  config = function()
    -- Load custom snippets
    require("luasnip.loaders.from_lua").load({ paths = "./lua/luasnippets" })
  end,
}
