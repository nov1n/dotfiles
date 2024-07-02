return {
  "mrcjkb/rustaceanvim",
  opts = {
    server = {
      default_settings = {
        ["rust-analyzer"] = {
          workspace = {
            symbol = {
              search = {
                scope = "workspace_and_dependencies",
              },
            },
          },
        },
      },
    },
  },
}
