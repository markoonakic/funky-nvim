return {
	"echasnovski/mini.icons",
	lazy = true,
	opts = {
		file = {
			[".gitignore"] = { glyph = "󰊢", hl = "MiniIconsOrange" },
			[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
			[".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
			["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			[".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
			[".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
			[".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
			[".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
			["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
			["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
			["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
			["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
			["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
			["config"] = { glyph = "", hl = "MiniIconsBlue" },
			[".project"] = { glyph = "", hl = "MiniIconsBlue" },
			[".classpath"] = { glyph = "", hl = "MiniIconsBlue" },
			["license"] = { glyph = "", hl = "MiniIconsYellow" },
		},
		filetype = {
			dotenv = { glyph = "", hl = "MiniIconsYellow" },
			gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
		},
	},
	init = function()
		package.preload["nvim-web-devicons"] = function()
			require("mini.icons").mock_nvim_web_devicons()
			return package.loaded["nvim-web-devicons"]
		end
	end,
}
