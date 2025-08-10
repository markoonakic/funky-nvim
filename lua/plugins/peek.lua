return {
	"toppair/peek.nvim",
	build = "deno task --quiet build:fast",
	ft = "markdown",
	config = function()
		require("peek").setup({
			auto_load = true, -- automatically loads preview when entering markdown buffer
			close_on_bdelete = true, -- close preview when changing/closing buffer
			syntax = true, -- enable syntax highlighting
			theme = "dark", -- 'dark' or 'light'
			update_on_change = true,
			app = "webview", -- 'webview' or 'browser'
		})

		-- Create user commands
		vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
		vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
	end,
}
