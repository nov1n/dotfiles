return {
  "saghen/blink.cmp",
  dependencies = { "fang2hou/blink-copilot" },
  config = function()
    require("blink.cmp").setup({
      completion = {
        documentation = {
          auto_show = true,
          window = {
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
          },
        },
        menu = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
            opts = {
              max_completions = 3, -- Override global max_completions
            },
          },
        },
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },
      snippets = {
        preset = "luasnip",
      },
      keymap = {
        preset = "default",
      },
      enabled = function()
        return not string.match(U.get_buf_path(), "/Journal/")
      end,
      appearance = {
        kind_icons = {
          Copilot = "",
          Text = "",
          Method = "m",
          Function = "󰊕",
          Constructor = "",
          Field = "",
          Variable = "",
          Class = "",
          Interface = "",
          Module = "",
          Property = " ",
          Unit = "",
          Value = "󰎠",
          Enum = "",
          Keyword = "󰌋",
          Snippet = "",
          Color = "󰏘",
          File = "󰈙",
          Reference = "",
          Folder = "󰉋",
          EnumMember = "",
          Constant = "󰏿",
          Struct = "",
          Event = "",
          Operator = "󰆕",
          TypeParameter = " ",
        },
      },
    })
  end,
}
