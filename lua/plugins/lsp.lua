return {
	-- Mason
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonUpdate", "MasonInstall", "MasonLog", "MasonUninst", "MasonUninstAll" },
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			-- mason-lspconfig: ONLY self-contained LSPs (always work)
			require("mason-lspconfig").setup({
				ensure_installed = {
					-- LSPs: Always work anywhere (no external runtimes)
					"lua_ls",
					"luau_lsp",
					"rust_analyzer",
					"taplo",
					"marksman",
					"ltex",
					"yamlls",
				},
				automatic_installation = false, -- No spam/errors
			})

			-- mason-tool-installer: Self-contained formatters + DAP + utils
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Formatters: Self-contained or lightweight
					"stylua",
					"shfmt",
					"prettierd",
					"prettier",

					-- DAP: Self-contained debuggers
					"codelldb",

					-- Utilities: Always useful
					"lemonade",
					"llm-ls",
				},
			})
		end,
		build = ":MasonUpdate",
		keys = {
			{ "<leader>ms", "<cmd>Mason<CR>", desc = "󰽤 Open Mason" },
		},
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"folke/lazydev.nvim",
			"mason-org/mason.nvim",
			{ "hrsh7th/cmp-nvim-lsp", enabled = false },
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
			if ok_cmp then
				capabilities = cmp.default_capabilities(capabilities)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }
					local map = vim.keymap.set
					local has_snacks = _G.Snacks ~= nil
					local has_fzf = pcall(require, "fzf-lua")

					if not has_snacks and not has_fzf then
						opts.desc = " LSP Go to definition"
						map("n", "gd", vim.lsp.buf.definition, opts)

						opts.desc = " LSP Go to declaration"
						map("n", "gD", vim.lsp.buf.declaration, opts)

						opts.desc = " Show LSP references"
						map("n", "gr", vim.lsp.buf.references, opts)

						opts.desc = " LSP Go to implementation"
						map("n", "gi", vim.lsp.buf.implementation, opts)

						opts.desc = " LSP Go to type definition"
						map("n", "gt", vim.lsp.buf.type_definition, opts)

						opts.desc = " LSP Document symbols"
						map("n", "<leader>ds", vim.lsp.buf.document_symbol, opts)
					end

					opts.desc = "󰌶 LSP See available code actions"
					map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

					opts.desc = "󰑕 LSP rename"
					map("n", "<leader>rn", vim.lsp.buf.rename, opts)

					opts.desc = "󰈙 LSP Show documentation under cursor"
					map("n", "gh", vim.lsp.buf.hover, opts)

					opts.desc = "󰜉 Restart LSP"
					map("n", "<leader>rs", ":LspRestart<CR>", opts)

					opts.desc = "󰊕 LSP Signature help"
					map("n", "K", vim.lsp.buf.signature_help, opts)
					map("i", "<C-k>", vim.lsp.buf.signature_help, opts)
				end,
			})

			local cfg = vim.lsp.config

			-- Always configure LSPs (they'll work when binaries exist)
			cfg("emmet_language_server", {
				filetypes = {
					"css",
					"html",
					"javascript",
					"javascriptreact",
					"less",
					"sass",
					"scss",
					"svelte",
					"typescriptreact",
					"vue",
				},
				settings = {
					emmet = {
						showExpandedAbbreviation = "always",
						showAbbreviationSuggestions = true,
						showSuggestionsAsSnippets = false,
						preferences = { ["bem.enabled"] = true },
					},
				},
				capabilities = capabilities,
			})

			cfg("lua_ls", {
				settings = {
					Lua = { hint = { enable = true } },
				},
				capabilities = capabilities,
			})

			cfg("clangd", {
				settings = {
					clangd = {
						InlayHints = {
							Designators = true,
							Enabled = true,
							ParameterNames = true,
							DeducedTypes = true,
						},
						fallbackFlags = { "-std=c++20" },
					},
				},
				capabilities = capabilities,
			})

			cfg("gopls", {
				settings = {
					gopls = {
						hints = {
							rangeVariableTypes = true,
							parameterNames = true,
							constantValues = true,
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							functionTypeParameters = true,
						},
					},
				},
				capabilities = capabilities,
			})

			cfg("vtsls", {
				settings = {
					typescript = {
						inlayHints = {
							parameterNames = { enabled = "all" },
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = true },
						},
					},
				},
				capabilities = capabilities,
			})

			cfg("marksman", {
				filetypes = { "markdown" },
				capabilities = capabilities,
			})

			cfg("ltex", {
				filetypes = { "markdown" },
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.semanticTokensProvider = nil
				end,
				settings = {
					ltex = {
						language = "en-US",
						additionalRules = { motherTongue = "en" },
					},
				},
				capabilities = capabilities,
			})

			-- Enable ALL LSPs (gracefully fail if binary missing)
			vim.lsp.enable({
				"lua_ls",
				"luau_lsp",
				"rust_analyzer",
				"taplo",
				"marksman",
				"ltex",
				"yamlls",
				"html",
				"cssls",
				"clangd",
				"gopls",
				"vtsls",
				"emmet_language_server",
			})
		end,
	},
}
