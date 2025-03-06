return {

  {
    'neovim/nvim-lspconfig',
    dependencies = { 'williamboman/mason-lspconfig.nvim', 'hrsh7th/cmp-nvim-lsp' },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lspconfig = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')
      local cmp_nvim_lsp = require('cmp_nvim_lsp')

      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- local function on_attach(client, bufnr)
      --   print(client.name .. " LSP started")
      -- end

      local lsp_flags = {
        debounce_text_changes = 150,
      }

      local servers = {
        bashls = {
          filetypes = { 'sh', 'bash' },
        },
        -- yamlls = {
        --   filetypes = { 'yaml', 'yml' },
        -- },
      }

      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers), -- Installerar alla servrar i listan
      })

      for server, config in pairs(servers) do
        lspconfig[server].setup(vim.tbl_deep_extend('force', {
          -- on_attach = on_attach,
          capabilities = capabilities,
          flags = lsp_flags,
        }, config))
      end
    end,
  },

  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    config = function()
      local mason = require('mason')

      mason.setup({
        ui = {
          icons = {
            package_installed = ' ',
            package_pending = ' ',
            package_uninstalled = ' ',
          },
        },
      })
    end,
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
    config = function()
      local mason_lspconfig = require('mason-lspconfig')

      mason_lspconfig.setup({
        --> Only LSP servers (auto-install)
        ensure_installed = {
          'bashls',
          --'ts_ls',
          --'lua_ls',
          --'marksman',
          --'vimls',
          --'yamlls',
          --'jsonls',
        },
        automatic_installation = true,
      })
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind.nvim',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
        formatting = {
          format = require('lspkind').cmp_format({ with_text = true }),
        },
      })
    end,
  },

  --> Treesitter requires c-compiler on system to install lang parsers
  --> Not required to use

  -- {
  --   'nvim-treesitter/nvim-treesitter',
  --   run = ':TSUpdate',
  --   event = { 'BufReadPre', 'BufNewFile' },
  --   config = function()
  --     require('nvim-treesitter.configs').setup({
  --       ensure_installed = {
  --         'bash',
  --         --  'vim',
  --         -- 'lua',
  --         --'markdown',
  --         --'markdown_inline',
  --         -- 'json',
  --         --   'jsonc',
  --       },
  --       sync_install = false,
  --       auto_install = false,
  --       -- fold = { enable = false },
  --       highlight = {
  --         enable = true,
  --         additional_vim_regex_highlighting = true,
  --       },
  --     })
  --   end,
  -- },
}
