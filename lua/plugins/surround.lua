return {
	"kylechui/nvim-surround",
	event = "VeryLazy",
	opts = {
		keymaps = {
			normal = "gsa",
			normal_cur = "gsA",
			visual = "gsa",
			delete = "gsd",
			change = "gsr",
		},
	},
}
