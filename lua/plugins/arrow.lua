return {
	"otavioschwanck/arrow.nvim",
	event = { "BufReadPre" },
	dependencies = { "echasnovski/mini.icons" },
	opts = {
		show_icons = true,
		leader_key = "<leader>mf",
		buffer_leader_key = "<leader>mb",
	},
}
