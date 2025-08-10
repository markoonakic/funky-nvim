return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	opts = {
		float = { max_width = 0.3, max_height = 0.2 },
		default_file_explorer = true,
		view_options = { show_hidden = true },
	},

  --stylua: ignore
  keys = {
    { "<leader>oi", function() require("oil").toggle_float() end, desc = "Open Floating Oil Nvim", },
  },
}
