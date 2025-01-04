return {
  "saghen/blink.cmp",
  dependencies = {
    {
      "giuxtaposition/blink-cmp-copilot",
    },
  },
  config = function()
    require("blink.cmp").setup({
      completion = {
        menu = {
          draw = {
            components = {
              label = {
                width = { fill = true, max = 60 },
                text = function(ctx)
                  local highlights_info = require("colorful-menu").highlights(ctx.item, vim.bo.filetype)
                  if highlights_info ~= nil then
                    return highlights_info.text
                  else
                    return ctx.label
                  end
                end,
                highlight = function(ctx)
                  local highlights_info = require("colorful-menu").highlights(ctx.item, vim.bo.filetype)
                  local highlights = {}
                  if highlights_info ~= nil then
                    for _, info in ipairs(highlights_info.highlights) do
                      table.insert(highlights, {
                        info.range[1],
                        info.range[2],
                        group = ctx.deprecated and "BlinkCmpLabelDeprecated" or info[1],
                      })
                    end
                  end
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                  end
                  return highlights
                end,
              },
            },
          },
        },
      },
    })
  end,
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    keymap = {
      preset = "default",
      ["<C-enter>"] = {},
      ["<Tab>"] = {},
      ["<S-Tab>"] = {},
      ["<Right>"] = { "snippet_forward" },
      ["<Left>"] = { "snippet_backward" },
    },
    enabled = function()
      return not string.match(U.get_buf_path(), "/Journal/")
    end,
    appearance = {
      -- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
      kind_icons = {
        Copilot = "",
        Text = "󰉿",
        Method = "󰊕",
        Function = "󰊕",
        Constructor = "󰒓",

        Field = "󰜢",
        Variable = "󰆦",
        Property = "󰖷",

        Class = "󱡠",
        Interface = "󱡠",
        Struct = "󱡠",
        Module = "󰅩",

        Unit = "󰪚",
        Value = "󰦨",
        Enum = "󰦨",
        EnumMember = "󰦨",

        Keyword = "󰻾",
        Constant = "󰏿",

        Snippet = "󱄽",
        Color = "󰏘",
        File = "󰈔",
        Reference = "󰬲",
        Folder = "󰉋",
        Event = "󱐋",
        Operator = "󰪚",
        TypeParameter = "󰬛",
      },
    },
  },
}
