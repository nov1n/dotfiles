return {
  {
    "nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
        update_in_insert = true,
        float = {
          enable = false,
          spacing = 4,
          border = "rounded",
          focusable = true,
          source = "if_many",
        },
        severity_sort = true,
      },
    },
  },
}
