return {

	{
		"neovim/nvim-lspconfig",
	},

	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			local mason = require("mason")

			mason.setup({
				ui = {
					icons = {
						package_installed = " ",
						package_pending = " ",
						package_uninstalled = " ",
					},
				},
			})
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
					["C-Space"] = cmp.mapping.complete({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
					["C-d"] = cmp.mapping.scroll_docs(-4),
					["C-f"] = cmp.mapping.scroll_docs(4),
				}),
				sources = cmp.config.sources({
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
				formatting = {
					format = require("lspkind").cmp_format({ with_text = true }),
				},
			})
		end,
	},

	--> Treesitter requires c-compiler on system to install lang parsers (not req; but nice)
	--> requires 'tree-sitter-cli' from NPM and NodeJS + build-essential from APT.

	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main", -- latest
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			-- install parsers
			ts.install({
				"bash",
				"dockerfile",
				"gitcommit",
				"git_config",
				"gitignore",
				"git_rebase",
				"javascript",
				"json",
				"regex", -- for cmdline hl
				"tsx",
				"typescript",
				"yaml",
			})
		end,
	},

	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		keys = {
			{
				"<leader>-",
				function()
					require("oil").toggle_float()
				end,
				desc = "Toggle Oil (float)",
			},
		},
		-- https://github.com/stevearc/oil.nvim
		opts = {},
	},

	{
		"stevearc/conform.nvim",
		event = { "InsertEnter" },
		init = function()
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("kjs.format", { clear = true }),
				desc = "format buf with conform (on save/write)",
				pattern = "*",
				callback = function(args)
					local bufnr = args.buf
					if vim.bo[bufnr].filetype == "hyprlang" then
						local view = vim.fn.winsaveview()
						vim.cmd("silent keepjumps keepmarks normal! gg=G")
						vim.fn.winrestview(view)
						return
					end

					require("conform").format({
						bufnr = args.buf,
						lsp_format = "fallback",
						timeout_ms = 500,
						stop_after_first = true,
						async = false,
					})
				end,
			})
		end,
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				markdown = { "prettierd" },
				yaml = { "prettierd" }, -- or "yamlfmt"
				sh = { "shfmt" },
			},
			notify_no_formatters = true,
		},
	},
}
