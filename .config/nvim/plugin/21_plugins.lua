local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Colorscheme
now(function()
  add({ source = 'folke/tokyonight.nvim', })
  vim.cmd('colorscheme tokyonight')
end)

-- Tree-sitter (advanced syntax parsing, highlighting, textobjects)
later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  add({ source = 'nvim-treesitter/nvim-treesitter-textobjects' })

  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      "bash",
      "hcl",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "terraform",
      "yaml",
      'bash',
      'c',
      'cpp',
      'css',
      'diff',
      'go',
      'html',
      'javascript',
      'json',
      'julia',
      'nu',
      'php',
      'python',
      'r',
      'regex',
      'rst',
      'rust',
      'toml',
      'tsx',
      'yaml',
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    textobjects = { select = { enable = true } },
  }
end)

-- Install LSP/formatting/linter executables
later(function()
  add('mason-org/mason.nvim')
  require('mason').setup()
end)

-- LSP Configuration
later(function()
  add('neovim/nvim-lspconfig')

  -- All language servers are expected to be installed with 'mason.nvim'
  vim.lsp.enable({
    'lua_ls',
    'rust_analyzer',
    'ts_ls',
  })
end)

-- Lua development environment
later(function()
  add({
    source = 'folke/lazydev.nvim',
    depends = {
      'nvim-lua/plenary.nvim',
      'gonstoll/wezterm-types',
    },
  })

  require('lazydev').setup({
    library = {
      { path = 'wezterm-types', mods = { 'wezterm' } },
    },
  })
end)

-- Formatting =================================================================
later(function()
  add('stevearc/conform.nvim')

  require('conform').setup({
    -- Map of filetype to formatters
    formatters_by_ft = {
      javascript = { 'prettier' },
      sh = { 'shfmt' },
      json = { 'prettier' },
      lua = { 'stylua' },
      python = { 'black' },
    },

    formatters = {
      shfmt = {
        prepend_args = { "-i", "2", "-ci" },
      },
      prettier = {
        prepend_args = { "--prose-wrap=always" },
      },
    },
  })
end)

-- Obsidian integration
later(function()
  add({
    source = 'epwalsh/obsidian.nvim',
    depends = {
      'nvim-lua/plenary.nvim',
    },
  })

  require('obsidian').setup({
    daily_notes = {
      folder = 'Journal',
      default_tags = { 'journal' },
    },
    templates = {
      folder = 'Templates',
      date_format = '%Y-%m-%d-%a',
      time_format = '%H:%M',
      substitutions = {
        yesterday = function()
          return os.date('%Y-%m-%d', os.time() - 86400)
        end,
      },
    },
    workspaces = {
      {
        name = 'personal',
        path = '~/Notes',
      },
    },
    picker = {
      name = 'mini.pick',
    },
  })
end)

-- Git integration
later(function()
  add({ source = 'kdheepak/lazygit.nvim'})
end)

-- Git blame
later(function()
  add({
    source = 'FabijanZulj/blame.nvim'
  })
  require('blame').setup()
end)

-- Smart window splitting
later(function()
  add({
    source = 'mrjones2014/smart-splits.nvim'
  })
end)
