return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = false,
  -- stylua: ignore
  keys = {
    { "<leader>oo",  "<cmd>ObsidianOpen<CR>",           { desc = "Open Obsidian" } },
    { "<leader>onn", "<cmd>ObsidianNew<CR>",            { desc = "Create a new note" } },
    { "<leader>oq",  "<cmd>ObsidianQuickSwitch<CR>",    { desc = "Quickly switch to another note" } },
    { "<leader>of",  "<cmd>ObsidianFollowLink<CR>",     { desc = "Follow a note reference" } },
    { "<leader>ob",  "<cmd>ObsidianBacklinks<CR>",      { desc = "Get backlinks for the current buffer" } },
    { "<leader>ott", "<cmd>ObsidianTags<CR>",           { desc = "Get a list of notes by tag" } },
    { "<leader>oj",  "<cmd>ObsidianToday<CR>",          { desc = "Open/create today's daily note" } },
    { "<leader>oy",  "<cmd>ObsidianYesterday<CR>",      { desc = "Open/create yesterday's daily note" } },
    { "<leader>otm", "<cmd>ObsidianTomorrow<CR>",       { desc = "Open/create tomorrow's daily note" } },
    { "<leader>oa",  "<cmd>ObsidianDailies<CR>",        { desc = "Open a list of daily notes" } },
    { "<leader>os",  "<cmd>ObsidianSearch<CR>",         { desc = "Search for notes in your vault" } },
    { "<leader>ol",  "<cmd>ObsidianLink<CR>",           { desc = "Link an inline visual selection of text to a note" },   },
    { "<leader>onl", "<cmd>ObsidianLinkNew<CR>",        { desc = "Create new note and link it to the visual selection" }, },
    { "<leader>ol",  "<cmd>ObsidianLinks<CR>",          { desc = "Collect all links within the current buffer" } },
    { "<leader>oe",  "<cmd>ObsidianExtractNote<CR>",    { desc = "Extract the selected text into a new note" } },
    { "<leader>ow",  "<cmd>ObsidianWorkspace<CR>",      { desc = "Switch to another workspace" } },
    { "<leader>op",  "<cmd>ObsidianPasteImg<CR>",       { desc = "Paste an image from the clipboard" } },
    { "<leader>or",  "<cmd>ObsidianRename<CR>",         { desc = "Rename the current note" } },
    { "<leader>oc",  "<cmd>ObsidianToggleCheckbox<CR>", { desc = "Cycle through checkbox options" } },
    { "<leader>otc", "<cmd>ObsidianTOC<CR>",            { desc = "Load the table of contents" } },
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
