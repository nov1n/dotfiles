-- ┌─────────────────────────┐
-- │ Plugins outside of MINI │
-- └─────────────────────────┘
--
-- This file contains installation and configuration of plugins outside of MINI.
-- They significantly improve user experience in a way not yet possible with MINI.
-- These are mostly plugins that provide programming language specific behavior.
--
-- Use this file to install and configure other such plugins.

-- Make concise helpers for installing/adding plugins in two stages
local add = vim.pack.add
local now_if_args, later = Config.now_if_args, Config.later

-- Tree-sitter ================================================================

-- Tree-sitter is a tool for fast incremental parsing. It converts text into
-- a hierarchical structure (called tree) that can be used to implement advanced
-- and/or more precise actions: syntax highlighting, textobjects, indent, etc.
--
-- Tree-sitter support is built into Neovim (see `:h treesitter`). However, it
-- requires two extra pieces that don't come with Neovim directly:
-- - Language parsers: programs that convert text into trees. Some are built-in
--   (like for Lua), 'nvim-treesitter' provides many others.
--   NOTE: It requires third party software to build and install parsers.
--   See the link for more info in "Requirements" section of the MiniMax README.
-- - Query files: definitions of how to extract information from trees in
--   a useful manner (see `:h treesitter-query`). 'nvim-treesitter' also provides
--   these, while 'nvim-treesitter-textobjects' provides the ones for Neovim
--   textobjects (see `:h text-objects`, `:h MiniAi.gen_spec.treesitter()`).
--
-- Add these plugins now if file (and not 'mini.starter') is shown after startup.
--
-- Troubleshooting:
-- - Run `:checkhealth vim.treesitter nvim-treesitter` to see potential issues.
-- - In case of errors related to queries for Neovim bundled parsers (like `lua`,
--   `vimdoc`, `markdown`, etc.), manually install them via 'nvim-treesitter'
--   with `:TSInstall <language>`. Be sure to have necessary system dependencies
--   (see MiniMax README section for software requirements).
now_if_args(function()
  -- Define hook to update tree-sitter parsers after plugin is updated
  local ts_update = function()
    vim.cmd("TSUpdate")
  end
  Config.on_packchanged("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")

  add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  })

  -- Define languages which will have parsers installed and auto enabled
  -- After changing this, restart Neovim once to install necessary parsers. Wait
  -- for the installation to finish before opening a file for added language(s).
  local languages = {
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
    "vimdoc",
    "xml",
    "yaml",
  }
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then
    require("nvim-treesitter").install(to_install)
  end

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  local ts_start = function(ev)
    vim.treesitter.start(ev.buf)
  end
  Config.new_autocmd("FileType", filetypes, ts_start, "Start tree-sitter")
end)

-- Language servers ===========================================================

-- Language Server Protocol (LSP) is a set of conventions that power creation of
-- language specific tools. It requires two parts:
-- - Server - program that performs language specific computations.
-- - Client - program that asks server for computations and shows results.
--
-- Here Neovim itself is a client (see `:h vim.lsp`). Language servers need to
-- be installed separately based on your OS, CLI tools, and preferences.
-- See note about 'mason.nvim' at the bottom of the file.
--
-- Neovim's team collects commonly used configurations for most language servers
-- inside 'neovim/nvim-lspconfig' plugin.
--
-- Add it now if file (and not 'mini.starter') is shown after startup.
now_if_args(function()
  add({ "https://github.com/neovim/nvim-lspconfig" })

  -- Enable language servers (must be installed via OS package manager)
  -- On macOS: brew install lua-language-server rust-analyzer typescript-language-server etc.
  vim.lsp.enable({
    "lua_ls",
    "rust_analyzer",
    "ts_ls",
    "ty",
    "bashls",
    "helm_ls",
    "yamlls",
    "jsonls",
    "taplo",
  })

  -- Custom LSP server configuration
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
end)

-- Formatting =================================================================

-- Programs dedicated to text formatting (a.k.a. formatters) are very useful.
-- Neovim has built-in tools for text formatting (see `:h gq` and `:h 'formatprg'`).
-- They can be used to configure external programs, but it might become tedious.
--
-- The 'stevearc/conform.nvim' plugin is a good and maintained solution for easier
-- formatting setup.
later(function()
  add({ "https://github.com/stevearc/conform.nvim" })

  -- See also:
  -- - `:h Conform`
  -- - `:h conform-options`
  -- - `:h conform-formatters`
  require("conform").setup({
    default_format_opts = {
      -- Allow formatting from LSP server if no dedicated formatter is available
      lsp_format = "fallback",
    },
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
        prepend_args = { "-i", "2", "-ci", "-bn" },
      },
      prettier = {
        prepend_args = { "--prose-wrap=always" },
      },
      -- Custom xmlformatter: uses xmlformat with post-processing to add space before />
      -- This preserves self-closing tags like <relativePath /> instead of <relativePath/>
      xmlformatter = {
        command = "sh",
        args = {
          "-c",
          "xmlformat --indent 4 --blanks --selfclose - | sed 's#/># />#g'",
        },
        stdin = true,
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
end)

-- Snippets ===================================================================

-- Although 'mini.snippets' provides functionality to manage snippet files, it
-- deliberately doesn't come with those.
--
-- The 'rafamadriz/friendly-snippets' is currently the largest collection of
-- snippet files. They are organized in 'snippets/' directory (mostly) per language.
-- 'mini.snippets' is designed to work with it as seamlessly as possible.
-- See `:h MiniSnippets.gen_loader.from_lang()`.
later(function()
  add({ "https://github.com/rafamadriz/friendly-snippets" })
end)

-- Linting ====================================================================

later(function()
  add({ "https://github.com/mfussenegger/nvim-lint" })

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
end)

-- Additional Plugins ==========================================================

-- Colorscheme
Config.now(function()
  add({ "https://github.com/folke/tokyonight.nvim" })
  vim.cmd("colorscheme tokyonight")
end)

-- Lua development environment
later(function()
  add({
    "https://github.com/folke/lazydev.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/gonstoll/wezterm-types",
  })

  require("lazydev").setup({
    library = {
      { path = "wezterm-types", mods = { "wezterm" } },
    },
  })
end)

-- Git integration
later(function()
  add({ "https://github.com/kdheepak/lazygit.nvim" })
end)

later(function()
  add({ "https://github.com/trevorhauter/gitportal.nvim" })
end)

-- Window management
later(function()
  add({ "https://github.com/mrjones2014/smart-splits.nvim" })
end)

later(function()
  add({ "https://github.com/folke/zen-mode.nvim" })

  require("zen-mode").setup({
    window = {
      width = 82,
      options = {
        signcolumn = "no",
        number = false,
        relativenumber = false,
        cursorline = false,
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
        laststatus = 0,
      },
    },
  })
end)

-- LSP breadcrumbs
later(function()
  add({ "https://github.com/SmiteshP/nvim-navic" })

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

  -- Update winbar when navic updates
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorMoved", "InsertLeave" }, {
    callback = function()
      if vim.tbl_contains(navic_filetypes, vim.bo.filetype) then
        if navic.is_available() then
          vim.opt_local.winbar = " %{%v:lua.require('nvim-navic').get_location()%}"
        else
          vim.opt_local.winbar = " "
        end
      end
    end,
  })
end)

-- AI assistant
later(function()
  add({ "https://github.com/NickvanDyke/opencode.nvim" })
  vim.g.opencode_opts = {}
end)

-- CSV viewer
later(function()
  add({ "https://github.com/hat0uma/csvview.nvim" })
end)

-- Markdown preview
later(function()
  add({ "https://github.com/brianhuster/live-preview.nvim" })
end)

-- Obsidian integration (Mac only)
if vim.fn.has("mac") == 1 then
  later(function()
    add({ "https://github.com/epwalsh/obsidian.nvim" })

    require("obsidian").setup({
      ui = {
        enable = false,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
        },
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
  end)
end

-- Override vim.paste to enable Cmd+V paste in picker
local paste_orig = vim.paste
vim.paste = function(lines, phase)
  if MiniPick.is_picker_active() then
    -- Paste into picker query
    local text = table.concat(lines, "")
    MiniPick.set_picker_query(vim.split(text, ""))
    return true
  end
  return paste_orig(lines, phase)
end

-- Honorable mentions =========================================================

-- 'mason-org/mason.nvim' (a.k.a. "Mason") is a great tool (package manager) for
-- installing external language servers, formatters, and linters. It provides
-- a unified interface for installing, updating, and deleting such programs.
--
-- The caveat is that these programs will be set up to be mostly used inside Neovim.
-- If you need them to work elsewhere, consider using other package managers.
--
-- You can use it like so:
-- now_if_args(function()
--   add({ 'https://github.com/mason-org/mason.nvim' })
--   require('mason').setup()
-- end)

-- Beautiful, usable, well maintained color schemes outside of 'mini.nvim' and
-- have full support of its highlight groups. Use if you don't like 'miniwinter'
-- enabled in 'plugin/30_mini.lua' or other suggested 'mini.hues' based ones.
-- Config.now(function()
--  -- Install only those that you need
--  add({
--    'https://github.com/sainnhe/everforest',
--    'https://github.com/Shatur/neovim-ayu',
--    'https://github.com/ellisonleao/gruvbox.nvim',
--  })
--
--   -- Enable only one
--   vim.cmd('color everforest')
-- end)
