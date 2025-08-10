return {
	"folke/trouble.nvim",
	event = { "BufReadPost" },
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	opts = { focus = true },
	cmd = "Trouble",

	keys = {
		{ "<leader>dq", "<cmd>Trouble diagnostics toggle<cr>", desc = " Diagnostics (Trouble)" },
		{ "<leader>dQ", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = " Buffer Diagnostics (Trouble)" },
	},
}
