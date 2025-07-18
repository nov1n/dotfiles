local luasnip = require("luasnip")
local s = luasnip.snippet
local f = luasnip.function_node

luasnip.add_snippets("all", {
  s(
    "daydate",
    f(function()
      return os.date("%Y-%m-%d, %A")
    end)
  ),
})
