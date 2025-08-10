return {
	"saghen/blink.cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"rafamadriz/friendly-snippets",
		"fang2hou/blink-copilot",
	},

	version = "1.*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "super-tab",
		},

		cmdline = {
			keymap = {
				preset = "inherit",
			},
			completion = { menu = { auto_show = true } },
		},

		appearance = { nerd_font_variant = "mono" },
		signature = {
			window = { border = "single" },
		},
		completion = {
			menu = { border = "single" },
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				window = { border = "single" },
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer", "copilot" },
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
				},
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
