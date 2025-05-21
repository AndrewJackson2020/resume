vim.cmd [[packadd packer.nvim]]

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.clipboard = 'unnamedplus'

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
  }

  -- Plugins can have post-install/update hooks
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}

  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use {
    "olimorris/codecompanion.nvim",
    config = function()
      require("codecompanion").setup()
    end,
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    }
  }
 
  use {
    'nvim-tree/nvim-tree.lua',
     requires = {
       'nvim-tree/nvim-web-devicons',
     },
  }
  use {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use	{
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  }
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    window = {
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
  })

require("tokyonight").setup({
  transparent = true,
  styles = {
     sidebars = "transparent",
     floats = "transparent",
  }
})
vim.cmd [[colorscheme tokyonight]]

require("nvim-tree").setup()
require("mason").setup()


require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "rust_analyzer", "ruff_lsp"},
}

require 'lspconfig'.pyright.setup {}
require 'lspconfig'.gopls.setup({})
require 'lspconfig'.clangd.setup({ cmd = {'/etc/profiles/per-user/andrew/bin/clangd'} })
require 'lspconfig'.rust_analyzer.setup {
    cmd = {'/etc/profiles/per-user/andrew/bin/rust-analyzer'},
    settings = {
        ['rust-analyzer'] = {
            check = {
                command = "clippy";
            },
            diagnostics = {
                enable = true;
            }
        }
    }
}

require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "llama3",
    },
    inline = {
      adapter = "llama3",
    },
  },
  adapters = {
    llama3 = function()
      return require("codecompanion.adapters").extend("ollama", {
        name = "llama3", -- Give this adapter a different name to differentiate it from the default ollama adapter
        schema = {
          model = {
            default = "deepseek-r1:latest",
          },
          num_ctx = {
            default = 16384,
          },
          num_predict = {
            default = -1,
          },
        },
      })
    end,
  },
})

  -- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
end)

