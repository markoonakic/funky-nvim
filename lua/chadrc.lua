--@type ChadrcConfig

return {

	base46 = {
		theme = "gruvbox", -- default theme
		hl_add = {

			NvDashPluginStats = {
				fg = "#fb4934",
			},

			DiagnosticSignWarn = { link = "DiagnosticWarn" },
			DiagnosticSignError = { link = "DiagnosticError" },
			DiagnosticSignInfo = { link = "DiagnosticInfo" },
			DiagnosticSignHint = { link = "DiagnosticHint" },
		},
		hl_override = {

			NvDashAscii = {
				fg = "pink",
			},

			NvDashButtons = {
				fg = "white",
			},
		},
		integrations = {},
		changed_themes = {},
		transparency = true,
	},

	ui = {
		cmp = {
			icons = true,
			lspkind_text = true,
			style = "default", -- default/flat_light/flat_dark/atom/atom_colored
		},

		telescope = { style = "borderless" }, -- borderless / bordered

		statusline = {
			theme = "default", -- default/vscode/vscode_colored/minimal
			-- default/round/block/arrow separators work only for default statusline theme
			-- round and block will work for minimal theme only
			separator_style = "default",
			order = nil,
			modules = nil,
		},

		-- lazyload it when there are 1+ buffers
		tabufline = {
			enabled = true,
			lazyload = true,
			order = { "treeOffset", "buffers", "tabs", "btns" },
			modules = nil,
		},
	},

	nvdash = {
		load_on_startup = true,

		header = function()
			-- Frames already loaded in init.lua
			-- Just build cached header with gap
			if not _G.ascii_header_with_gap then
				if _G.ascii_frames and _G.ascii_frames[1] then
					local header = {}
					for _, line in ipairs(_G.ascii_frames[1]) do
						table.insert(header, line)
					end
					table.insert(header, "") -- Add 1 empty line for gap
					_G.ascii_header_with_gap = header
				end
			end

			return _G.ascii_header_with_gap or {}
		end,

		buttons = {
			{ txt = " Find File", keys = "f", cmd = ":lua Snacks.picker.files({ hidden = true })" },
			{ txt = "󱎸 RipGrep", keys = "g", cmd = ":lua Snacks.dashboard.pick('live_grep')" },
			{ txt = "󰦛 Restore Session", keys = "r", cmd = ":lua require('persistence').load()" },
			{ txt = " Pick Session", keys = "R", cmd = ":lua require('persistence').select()" },
			{ txt = " New File", keys = "n", cmd = ":ene | startinsert" },
			{ txt = " LazyGit", keys = "l", cmd = ":lua require('lazygit').lazygit()" },
			{ txt = "󰒲 Lazy", keys = "L", cmd = ":Lazy" },
			{ txt = " Mason", keys = "m", cmd = ":Mason" },
			{ txt = " Quit", keys = "q", cmd = ":qa" },

			{ txt = "─", hl = "NvDashPLuginStats", no_gap = true, rep = true },

			{
				txt = function()
					local stats = require("lazy").stats()
					local ms = math.floor(stats.startuptime) .. " ms"
					return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
				end,
				hl = "NvDashPLuginStats",
				no_gap = true,
				content = "fit",
			},

			{ txt = "─", hl = "NvDashPLuginStats", no_gap = true, rep = true },
		},
	},

	term = {
		winopts = { number = false, relativenumber = false },
		sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
		float = {
			relative = "editor",
			row = 0.3,
			col = 0.25,
			width = 0.5,
			height = 0.4,
			border = "single",
		},
	},

	lsp = { signature = true },

	cheatsheet = {
		theme = "grid", -- simple/grid
		excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
	},

	mason = { cmd = true, pkgs = {} },
}
