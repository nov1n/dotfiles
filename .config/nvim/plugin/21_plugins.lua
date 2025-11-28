-- Add all plugins in one call (mini.nvim is bootstrapped in init.lua)
local plugins = {
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/gonstoll/wezterm-types" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/mfussenegger/nvim-lint" },
  { src = "https://github.com/kdheepak/lazygit.nvim" },
  { src = "https://github.com/brianhuster/live-preview.nvim" },
  { src = "https://github.com/mrjones2014/smart-splits.nvim" },
  { src = "https://github.com/folke/zen-mode.nvim" },
  { src = "https://github.com/SmiteshP/nvim-navic" },
  { src = "https://github.com/NickvanDyke/opencode.nvim" },
  { src = "https://github.com/hat0uma/csvview.nvim" },
  { src = "https://github.com/trevorhauter/gitportal.nvim" },
  { src = "https://github.com/OXY2DEV/markview.nvim" },
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
    "c",
    "cpp",
    "css",
    "diff",
    "go",
    "hcl",
    "html",
    "javascript",
    "json",
    "jsonnet",
    "julia",
    "latex",
    "lua",
    "markdown",
    "markdown_inline",
    "nu",
    "php",
    "python",
    "query",
    "r",
    "regex",
    "rst",
    "rust",
    "terraform",
    "toml",
    "tsx",
    "typst",
    "xml",
    "yaml",
  },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
  textobjects = { select = { enable = true } },
})

-- Mason setup
require("mason").setup()

-- Mason-lspconfig setup (auto-enable LSP servers)
require("mason-lspconfig").setup({
  -- mason-tool-installer handles installation, we just need auto-enabling
  automatic_installation = true,
})

-- Mason-tool-installer setup (auto-install everything)
require("mason-tool-installer").setup({
  ensure_installed = {
    -- LSP servers (using lspconfig names thanks to mason-lspconfig integration)
    "lua_ls",
    "rust_analyzer",
    "ts_ls",
    "ty",
    "bash-language-server",
    "helm_ls",
    -- "kotlin_lsp",
    "lemminx",
    "yamlls",
    "jsonls",
    "taplo",

    -- Formatters
    "prettier",
    "shfmt",
    "jsonnetfmt",
    "stylua",
    "ruff",
    "xmlformatter",
    "ktfmt",
    "google-java-format",

    -- Linters
    "eslint_d",
    "shellcheck",
    "markdownlint",
    "yamllint",
  },
  auto_update = true,
  run_on_start = true,
})

vim.lsp.config("ty", {
  settings = {
    ty = {
      diagnosticMode = "workspace",
      experimental = {
        rename = true,
        autoImport = true,
      },
    },
  },
})

-- nvim-navic setup (breadcrumbs)
local function setup_navic()
  local navic = require("nvim-navic")

  -- Filetypes where navic winbar should be shown
  local navic_filetypes = { "xml", "yaml", "json", "toml" }

  -- Attach navic to LSP clients for specific filetypes
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      if vim.tbl_contains(navic_filetypes, vim.bo.filetype) then
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.documentSymbolProvider then
          navic.attach(client, args.buf)
        end
      end
    end,
  })

  -- Update winbar when navic updates (using same events navic uses internally)
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorMoved", "InsertLeave" }, {
    callback = function()
      if vim.tbl_contains(navic_filetypes, vim.bo.filetype) then
        if navic.is_available() then
          vim.opt_local.winbar = " %{%v:lua.require('nvim-navic').get_location()%}"
        else
          vim.opt_local.winbar = " " -- Reserve the line with a space
        end
      end
    end,
  })
end
setup_navic()

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
    html = { "prettier" },
    javascript = { "prettier" },
    sh = { "shfmt" },
    json = { "prettier" },
    jsonnet = { "jsonnetfmt" },
    lua = { "stylua" },
    python = {
      "ruff_fix",
      "ruff_format",
      "ruff_organize_imports",
    },
    xml = { "xmlformatter" },
    kotlin = { "ktfmt" },
    java = { "google-java-format" },
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
    xmlformatter = {
      prepend_args = { "--indent", "4", "--blanks" },
    },
  },

  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    -- Disable autoformat on save for Kotlin files
    if vim.bo[bufnr].filetype == "kotlin" then
      return
    end
    return { timeout_ms = 1000, lsp_format = "fallback" }
  end,
})

-- Linting setup
local lint = require("lint")

-- Map of filetype to linters
lint.linters_by_ft = {
  javascript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  markdown = { "markdownlint" },
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  yaml = { "yamllint" },
}

-- Auto-lint on save and text change
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    require("lint").try_lint()
  end,
})

-- Obsidian setup
if vim.fn.has("mac") == 1 then
  require("obsidian").setup({
    ui = {
      enable = false,
    },
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
