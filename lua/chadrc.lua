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
			-- Load frames once
			if not _G.ascii_frames then
				local ok, frames = pcall(dofile, vim.fn.expand("~/.config/nvim/lua/ascii_frames.lua"))
				if ok and frames and #frames > 0 then
					_G.ascii_frames = frames
					_G.ascii_frame_idx = 1
				end
			end

			-- Return empty placeholder - animation will render the frames
			local empty = {}
			for i = 1, 22 do
				table.insert(empty, "")
			end
			return empty
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
