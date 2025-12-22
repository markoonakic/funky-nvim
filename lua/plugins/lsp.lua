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

			-- Base LSPs that work without external runtimes
			local ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"taplo",
			}

			local lsp_enable_list = {
				"lua_ls",
				"rust_analyzer",
				"taplo",
				"marksman",
			}

			-- Conditionally add LSPs based on available runtimes
			if vim.fn.executable("npm") == 1 then
				vim.list_extend(ensure_installed, {
					"html",
					"cssls",
					"tailwindcss",
					"bashls",
					"jsonls",
					"emmet_language_server",
					"vtsls",
				})
				vim.list_extend(lsp_enable_list, {
					"html",
					"cssls",
					"tailwindcss",
					"bashls",
					"jsonls",
					"emmet_language_server",
					"vtsls",
				})
			end

			if vim.fn.executable("python3") == 1 then
				vim.list_extend(ensure_installed, { "ruff" })
				vim.list_extend(lsp_enable_list, { "ruff" })
			end

			if vim.fn.executable("go") == 1 then
				vim.list_extend(ensure_installed, { "gopls" })
				vim.list_extend(lsp_enable_list, { "gopls" })
			end

			if vim.fn.executable("clang") == 1 or vim.fn.executable("gcc") == 1 then
				vim.list_extend(ensure_installed, { "clangd" })
				vim.list_extend(lsp_enable_list, { "clangd" })
			end

			if vim.fn.executable("cmake") == 1 then
				vim.list_extend(ensure_installed, { "cmake" })
				vim.list_extend(lsp_enable_list, { "cmake" })
			end

			-- Always include ltex for markdown spellchecking (Java-based, usually available)
			vim.list_extend(ensure_installed, { "ltex" })
			vim.list_extend(lsp_enable_list, { "ltex" })

			-- mason-lspconfig v2
			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				automatic_installation = false,
			})

			-- Conditional tool installer
			local tools_installed = {}

			if vim.fn.executable("npm") == 1 then
				vim.list_extend(tools_installed, {
					"prettierd",
					"prettier",
					"eslint_d",
				})
			end

			if vim.fn.executable("python3") == 1 then
				vim.list_extend(tools_installed, {
					"isort",
					"black",
					"autopep8",
					"pylint",
				})
			end

			if vim.fn.executable("go") == 1 then
				vim.list_extend(tools_installed, {
					"gofumpt",
					"goimports-reviser",
					"delve",
					"golines",
				})
			end

			if vim.fn.executable("clang-format") == 1 then
				vim.list_extend(tools_installed, { "clang-format" })
			end

			if vim.fn.executable("lua") == 1 then
				vim.list_extend(tools_installed, { "stylua" })
			end

			if vim.fn.executable("bash") == 1 then
				vim.list_extend(tools_installed, { "shfmt" })
			end

			require("mason-tool-installer").setup({
				ensure_installed = tools_installed,
			})

			-- Store the LSP enable list globally for use in the lspconfig section
			_G.conditional_lsp_list = lsp_enable_list
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

			-- Enable only the LSPs that have their runtimes available
			vim.lsp.enable(_G.conditional_lsp_list or {
				"lua_ls",
				"rust_analyzer",
				"taplo",
				"marksman",
			})
		end,
	},
}
