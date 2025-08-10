return {
	"echasnovski/mini.cursorword",
	event = { "InsertEnter", "BufReadPost" },
	version = "*",
	config = function()
		require("mini.cursorword").setup({})
	end,
}
