return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
	opts = {
		ensure_installed = "all",
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },

		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["as"] = "@struct.outer",
					["is"] = "@struct.inner",
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
					["ai"] = "@conditional.outer",
					["ii"] = "@conditional.inner",
					["al"] = "@loop.outer",
					["il"] = "@loop.inner",
					["ab"] = "@block.outer",
					["ib"] = "@block.inner",
					["ad"] = "@comment.outer",
					["am"] = "@call.outer",
					["im"] = "@call.inner",
				},
			},

			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]f"] = "@function.outer",
					["]c"] = "@class.outer",
					["]s"] = "@struct.outer",
				},
				goto_next_end = {
					["]F"] = "@function.outer",
					["]C"] = "@class.outer",
					["]S"] = "@struct.outer",
				},
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[c"] = "@class.outer",
					["[s"] = "@struct.outer",
				},
				goto_previous_end = {
					["[F"] = "@function.outer",
					["[C"] = "@class.outer",
					["[S"] = "@struct.outer",
				},
			},

			lsp_interop = {
				enable = true,
				border = "none",
				floating_preview_opts = {},
				peek_definition_code = {
					["<leader>df"] = "@function.outer",
					["<leader>dF"] = "@class.outer",
				},
			},
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)

		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			callback = function()
				vim.cmd("TSBufEnable highlight")
			end,
		})
	end,
}
