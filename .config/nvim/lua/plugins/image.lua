return {
  {
    "3rd/image.nvim",
    -- So that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    -- Requires installing imagemagick
    build = false,
    opts = {
      integrations = {
        markdown = {
          -- Resolve images in Obsidian vault
          resolve_image_path = function(document_path, image_path, fallback)
            local notes_dir = vim.fn.expand(VARS.notes_dir)
            if document_path:find(notes_dir) then
              return notes_dir .. "/" .. image_path
            end
            return fallback(document_path, image_path)
          end,
        },
      },
    },
  },
}
