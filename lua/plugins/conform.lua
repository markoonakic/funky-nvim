return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        java = { "google-java-format" },
        go = { "gofumpt", "goimports-reviser" },
        bash = { "shfmt" },
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        jsx = { "prettierd", "prettier" },
        tsx = { "prettierd", "prettier" },
        python = { "isort", "black" },
      },

      format_after_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { async = true, lsp_fallback = true }
      end,
    })
  end,

  -- stylua: ignore
  keys = {
    { "<leader>fo", function() require("conform").format({ async = true, lsp_fallback = true }) end, { desc = " Format file or selection" } },
  },
}
