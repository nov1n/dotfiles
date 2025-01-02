return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = false,
  -- stylua: ignore
  keys = {
    { "<leader>o/",     "<cmd>ObsidianSearch<CR>",          { desc = "Search for notes in your vault" } },
    { "<leader>ob",     "<cmd>ObsidianBacklinks<CR>",       { desc = "Get backlinks for the current buffer" } },
    { "<leader>oc",     "<cmd>ObsidianToggleCheckbox<CR>",  { desc = "Cycle through checkbox options" } },
    { "<leader>oe",     "<cmd>ObsidianExtractNote<CR>",     { desc = "Extract the selected text into a new note" } },
    { "<leader>of",     "<cmd>ObsidianFollowLink<CR>",      { desc = "Follow a note reference" } },
    { "<leader>oja",    "<cmd>ObsidianDailies<CR>",         { desc = "Open a list of daily notes" } },
    { "<leader>ojj",    "<cmd>ObsidianToday<CR>",           { desc = "Open/create today's daily note" } },
    { "<leader>ojn",    "<cmd>ObsidianTomorrow<CR>",        { desc = "Open/create tomorrow's daily note" } },
    { "<leader>ojp",    "<cmd>ObsidianYesterday<CR>",       { desc = "Open/create yesterday's daily note" } },
    { "<leader>on",    "<cmd>ObsidianNew<CR>",             { desc = "Create a new note" } },
    { "<leader>oo",     "<cmd>ObsidianOpen<CR>",            { desc = "Open Obsidian" } },
    { "<leader>op",     "<cmd>ObsidianPasteImg<CR>",        { desc = "Paste an image from the clipboard" } },
    { "<leader>or",     "<cmd>ObsidianRename<CR>",          { desc = "Rename the current note" } },
    { "<leader>ol",     "<cmd>ObsidianTemplate<CR>",        { desc = "Insert a template" } },
    { "<leader>ot",     "<cmd>ObsidianTags<CR>",            { desc = "Get a list of notes by tag" } },
    --{ "<leader>ont",  "<cmd>ObsidianNewFromTemplate<CR>", { desc = "Create a new note from a template" } },
    -- { "<leader>ol",  "<cmd>ObsidianLink<CR>",            { desc = "Link an inline visual selection of text to a note" },   },
    -- { "<leader>ol",  "<cmd>ObsidianLinks<CR>",           { desc = "Collect all links within the current buffer" } },
    -- { "<leader>onl", "<cmd>ObsidianLinkNew<CR>",         { desc = "Create new note and link it to the visual selection" }, },
    -- { "<leader>oq",  "<cmd>ObsidianQuickSwitch<CR>",     { desc = "Quickly switch to another note" } },
    -- { "<leader>otc", "<cmd>ObsidianTOC<CR>",             { desc = "Load the table of contents" } },
    -- { "<leader>ow",  "<cmd>ObsidianWorkspace<CR>",       { desc = "Switch to another workspace" } },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
    "nvim-treesitter",
  },
  opts = {
    daily_notes = {
      folder = "Journal",
      default_tags = { "journal" },
    },
    templates = {
      folder = "Templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
      substitutions = {
        yesterday = function()
          return os.date("%Y-%m-%d", os.time() - 86400)
        end,
      },
    },
    workspaces = {
      {
        name = "personal",
        path = VARS.notes_dir,
      },
    },
    picker = {
      name = "fzf-lua",
    },
  },
}
