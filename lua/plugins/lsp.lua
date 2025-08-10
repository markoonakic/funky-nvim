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

      -- LSP setup
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "html",
          "cssls",
          "clangd",
          "ruff",
          "rust_analyzer",
          "cmake",
          "tailwindcss",
          "gopls",
          "bashls",
          "jsonls",
          "emmet_language_server",
          "vtsls",
          "taplo",
        },

        automatic_enable = false,
        automatic_installation = true,
      })

      -- Tool installer setup
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettierd",
          "prettier",
          "stylua",
          "isort",
          "black",
          "autopep8",
          "pylint",
          "eslint_d",
          "clang-format",
          "gofumpt",
          "goimports-reviser",
          "delve",
          "golines",
          "shfmt",
        },
      })
    end,

    build = ":MasonUpdate",

    keys = {
      { "<leader>ms", "<cmd>Mason<CR>", desc = "󰽤 Open Mason" },
    },
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "folke/lazydev.nvim",
      "mason-org/mason.nvim",
      { "hrsh7th/cmp-nvim-lsp", enabled = false },
    },

    config = function()
      local lspconfig = require("lspconfig")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          local map = vim.keymap.set
          local has_snacks = Snacks ~= nil
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

      -- Server-specific configurations
      local server_configs = {
        emmet_language_server = {
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
              preferences = {
                ["bem.enabled"] = true,
              },
            },
          },
        },

        lua_ls = {
          settings = {
            Lua = {
              hint = {
                enable = true,
              },
            },
          },
        },

        clangd = {
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
        },

        gopls = {
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
        },

        vtsls = {
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
        },
      }

      local installed_servers = require("mason-lspconfig").get_installed_servers()

      for _, server_name in ipairs(installed_servers) do
        local has_cmp, cmp = pcall(require, "cmp_nvim_lsp")
        local capabilities
        local config = {}
        if has_cmp then
          capabilities = cmp.default_capabilities()
          config = {
            capabilities = capabilities,
          }
        end

        if server_configs[server_name] then
          for k, v in pairs(server_configs[server_name]) do
            config[k] = v
          end
        end

        lspconfig[server_name].setup(config)
      end
    end,
  },
}
