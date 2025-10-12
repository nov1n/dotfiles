-- Add all plugins in one call (mini.nvim is bootstrapped in init.lua)
local plugins = {
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/gonstoll/wezterm-types" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/kdheepak/lazygit.nvim" },
  { src = "https://github.com/brianhuster/live-preview.nvim" },
  { src = "https://github.com/mrjones2014/smart-splits.nvim" },
  { src = "https://github.com/folke/zen-mode.nvim" },
  { src = "https://github.com/NickvanDyke/opencode.nvim" },
}

-- Obsidian integration (only on Mac)
if vim.fn.has("mac") == 1 then
  table.insert(plugins, { src = "https://github.com/epwalsh/obsidian.nvim" })
end

vim.pack.add(plugins, { load = true })

-- Builtin plugins
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")

-- =============================================================================
-- Plugin Setup and Configuration
-- =============================================================================

-- Colorscheme
vim.cmd("colorscheme tokyonight")

-- Tree-sitter configuration
---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "hcl",
    "html",
    "javascript",
    "json",
    "jsonnet",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "terraform",
    "yaml",
    "bash",
    "c",
    "cpp",
    "css",
    "diff",
    "go",
    "html",
    "javascript",
    "json",
    "julia",
    "nu",
    "php",
    "python",
    "r",
    "regex",
    "rst",
    "rust",
    "toml",
    "tsx",
    "yaml",
  },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
  textobjects = { select = { enable = true } },
})

-- Mason setup
require("mason").setup()

-- LSP Configuration
vim.lsp.enable({
  "lua_ls",
  "rust_analyzer",
  "ts_ls",
})

-- Lua development environment
require("lazydev").setup({
  library = {
    { path = "wezterm-types", mods = { "wezterm" } },
  },
})

-- Formatting setup
require("conform").setup({
  -- Map of filetype to formatters
  formatters_by_ft = {
    javascript = { "prettier" },
    sh = { "shfmt" },
    json = { "prettier" },
    jsonnet = { "jsonnetfmt" },
    lua = { "stylua" },
    python = { "black" },
    kotlin = { "ktfmt" },
    markdown = { "prettier" },
  },

  -- Customize formatters
  formatters = {
    ktfmt = {
      prepend_args = { "--kotlinlang-style" },
    },
    shfmt = {
      prepend_args = { "-i", "2", "-ci" },
    },
    prettier = {
      prepend_args = { "--prose-wrap=always" },
    },
  },

  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 1000, lsp_format = "fallback" }
  end,
})

-- Obsidian setup
if vim.fn.has("mac") == 1 then
  require("obsidian").setup({
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
        path = "~/Notes",
      },
    },
    picker = {
      name = "mini.pick",
    },
  })
end

-- Zen mode setup
require("zen-mode").setup({
  window = {
    width = 82,
    options = {
      signcolumn = "no", -- disable signcolumn
      number = false, -- disable number column
      relativenumber = false, -- disable relative numbers
      cursorline = false, -- disable cursorline
      cursorcolumn = false, -- disable cursor column
      foldcolumn = "0", -- disable fold column
      spell = false,
      list = false, -- disable whitespace characters
    },
  },
  plugins = {
    options = {
      enabled = true,
      ruler = false, -- disables the ruler text in the cmd line area
      showcmd = false, -- disables the command in the last line of the screen
      -- you may turn on/off statusline in zen mode by setting 'laststatus'
      -- statusline will be shown only if 'laststatus' == 3
      laststatus = 0, -- turn off the statusline in zen mode
    },
  },
})

-- OpenCode setup
vim.g.opencode_opts = {
  -- Configuration, if any — see lua/opencode/config.lua
}
