---@module 'snacks'

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		input = {
			enabled = true,
			win = { relative = "cursor", width = 60, row = -3, col = 0, style = "input" },
		},
		picker = {
			layout = "default",
			statusline = false,
			files = { hidden = true },
			sources = { explorer = { auto_close = true, hidden = true, ignored = true } },
		},
		dashboard = {
			enabled = false,
			preset = {

				keys = {
					{
						text = {
							{ "", hl = "SnacksDashboardIcon", width = 2, align = "left" },
							{ "Find File", hl = "SnacksDashboardDesc", width = 38, align = "left" },
							{ "f", hl = "SnacksDashboardKey", width = 0, align = "right" },
						},
						action = function()
							Snacks.picker.files({ hidden = true })
						end,
						key = "f",
					},
					{
						text = {
							{ "󱎸", hl = "SnacksDashboardIcon", width = 2, align = "left" },
							{ "RipGrep", hl = "SnacksDashboardDesc", width = 38, align = "left" },
							{ "g", hl = "SnacksDashboardKey", width = 0, align = "right" },
						},
						action = ":lua Snacks.dashboard.pick('live_grep')",
						key = "g",
					},
					{
						text = {
							{ "󰦛", hl = "SnacksDashboardIcon", width = 2, align = "left" },
							{ "Restore Session", hl = "SnacksDashboardDesc", width = 38, align = "left" },
							{ "r", hl = "SnacksDashboardKey", width = 0, align = "right" },
						},
						action = function()
							require("persistence").load()
						end,
						key = "r",
					},
					{
						text = {
							{ "", hl = "SnacksDashboardIcon", width = 2, align = "left" },
							{ "Pick Session", hl = "SnacksDashboardDesc", width = 38, align = "left" },
							{ "R", hl = "SnacksDashboardKey", width = 0, align = "right" },
						},
						action = function()
							require("persistence").select()
						end,
						key = "R",
					},
					{
						text = {
							{ "", hl = "SnacksDashboardIcon", width = 2, align = "left" },
							{ "New File", hl = "SnacksDashboardDesc", width = 38, align = "left" },
							{ "n", hl = "SnacksDashboardKey", width = 0, align = "right" },
						},
						action = ":ene | startinsert",
						key = "n",
					},
					{
						text = {
							{ "", hl = "SnacksDashboardIcon", width = 2, align = "left" },
							{ "LazyGit", hl = "SnacksDashboardDesc", width = 38, align = "left" },
							{ "l", hl = "SnacksDashboardKey", width = 0, align = "right" },
						},
						action = "<leader>lg",
						key = "l",
					},
					{
						text = {
							{ "󰒲", hl = "SnacksDashboardIcon", width = 2, align = "left" },
							{ "Lazy", hl = "SnacksDashboardDesc", width = 38, align = "left" },
							{ "L", hl = "SnacksDashboardKey", width = 0, align = "right" },
						},
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
						key = "L",
					},
					{
						text = {
							{ "", hl = "SnacksDashboardIcon", width = 2, align = "left" },
							{ "Mason", hl = "SnacksDashboardDesc", width = 38, align = "left" },
							{ "m", hl = "SnacksDashboardKey", width = 0, align = "right" },
						},
						action = ":Mason",
						key = "m",
					},
					{
						text = {
							{ "", hl = "SnacksDashboardIcon", width = 2, align = "left" },
							{ "Quit", hl = "SnacksDashboardDesc", width = 38, align = "left" },
							{ "q", hl = "SnacksDashboardKey", width = 0, align = "right" },
						},
						action = ":qa",
						key = "q",
					},
				},
				header = table.concat({
					"⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⠿⡟⡟⠙⠋⠛⠉⠝⡛⠟⣿⢙⠟⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⡟⢿⡏⠻⠆⠁⠐⠀⠉⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠜⠁⡿⢻⣽⢿⣿⣿⣿⣿⠿⣿⣿⠟⣩⣻⠿",
					"⣿⣿⣿⣟⢍⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠟⡹⣿⣿⣿⣿⠋⡴⡏⠀⠀⠐⠀⠐",
					"⣿⢿⣛⠛⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⣻⣿⣟⢔⠃⠑⠀⠀⠀⠀⠀⠀",
					"⣿⡇⠱⠀⠀⠀⠀⠀⠀⠀⠀⢀⢀⠔⠀⠀⠀⠁⠀⠠⠀⢀⠀⠀⠀⠀⢀⠀⢱⣽⣺⠍⠄⠂⠀⠀⠀⠀⠀⠀",
					"⣟⠣⠀⠀⠀⠀⠀⠀⠀⢠⠁⡔⠀⢀⠐⣠⣦⠔⠀⠀⠁⠀⠀⠀⠀⢀⠎⣀⠐⡽⡳⠀⠀⠀⠀⠀⠀⡆⠁⠀",
					"⡟⡉⠀⠀⠀⠀⠀⠀⠄⡁⠊⠁⠀⠀⡾⠋⢁⡐⡂⡂⠒⠐⠀⠀⠄⠀⡀⡠⠂⠈⠀⠀⡀⠀⠀⢀⠴⠀⠀⠀",
					"⣿⣔⠂⠀⠀⠀⡠⡔⠀⠀⡀⢄⢐⢀⣄⣶⣿⣿⣿⡙⠌⢑⠢⠀⠀⠀⠁⠀⠀⢀⠀⠀⠀⠀⠀⡘⠀⠀⠀⠀",
					"⣿⣶⡤⠀⠀⠈⠀⠀⠠⣬⣘⢊⡀⣩⣤⣿⠷⠀⠀⠈⠣⠠⠐⢈⢢⠀⠠⠀⠀⠘⡶⠀⠀⠀⠀⠀⠀⠀⠀⠀",
					"⣿⣿⣿⣷⡄⠀⢮⠚⢁⠑⠀⠀⡲⢛⢁⣤⡞⡦⠑⠔⠀⠈⠐⠄⠀⠐⡤⡱⠀⢢⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀",
					"⣿⣿⣿⣿⣷⣦⡈⢨⣾⢁⡷⠃⣠⡼⠿⠌⠁⠈⠀⠀⠀⠀⠀⠠⢘⣎⠨⡀⠇⠈⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀",
					"⣿⣿⣿⣿⣿⣿⣿⡆⠿⠂⠁⢸⡎⠃⠀⠀⠀⠀⠀⢀⣄⡤⠌⠑⡀⠊⢧⢳⡀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣦⡁⢀⠀⠁⠤⠂⠀⠐⣀⣐⣼⣿⠅⢠⡪⡓⡀⠈⡣⠡⠀⠀⠀⢀⠠⠀⠀⠀⠀⠀⠀",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⠀⠀⠂⢻⣿⡿⠏⠁⣼⡱⠖⠀⢀⠌⠀⢐⠀⠀⠀⢈⠀⠀⠀⠀⠀⠀",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠻⣿⢦⡁⠀⠀⠪⡡⡀⢦⠻⠆⢋⡤⠊⠠⠀⠀⢐⠀⠀⠀⡂⠀⠀⠀⣀⠁⠀",
					"⣿⣿⣿⣿⣿⡟⠱⣿⣿⢟⠄⠙⠁⢈⠈⠀⠂⠖⢌⠚⠈⡡⠞⠉⣀⣤⡮⠅⠀⠐⠄⠀⠂⠀⠀⠀⠀⠜⠀⠀",
					"⣿⣿⣿⣿⣿⡂⠊⢙⠘⡊⠡⠀⠂⠀⠀⠀⠀⠀⠀⢀⠈⢀⣤⠞⢋⠁⠀⠀⠀⠘⠀⠀⠁⠀⠀⠂⠀⠄⠀⠀",
					"⣿⣿⣿⣯⠨⠇⠀⠀⠀⠀⠀⠀⠀⡁⢀⠐⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⡀⠀⠀⠀⡀⠀⠀⠀⠀",
					"⣿⣿⣿⡯⠀⠀⠀⠐⠀⠄⠄⣀⠀⠈⠈⠙⠍⠌⢁⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀",
					"⣿⢡⠊⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢀⠀⡀⠀⠀⠀⢀⠀⠀⠀⡂⢀⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
					"⡏⢂⠀⠄⠀⠈⠒⠒⠠⠠⠐⡐⠂⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀",
				}, "\n"),
			},
			sections = {
				{ section = "header" },
				--{ text = { " " .. os.date("%A, %d %B %Y") }, hl = "SnacksDashboardDate", padding = 1, align = "center" },
				{ section = "keys", gap = 1, padding = 2, indent = 2, align = "center" },
				{ section = "startup" },
			},
		},
		explorer = { enabled = true, replace_netrw = true, auto_close = true },
		notifier = { enabled = true },
		bigfile = { enabled = true },
		quickfile = { enabled = true },
		terminal = { enabled = true },
		image = { enabled = true },
		words = { enabled = false },
		indent = { enabled = true },
		scroll = { enabled = false },
		zen = { enabled = true, toggles = { dim = false } },
		toggle = { enabled = true },
		lazygit = { enabled = true },
		statuscolumn = { enabled = true },
	},

  -- stylua: ignore
  keys = {
    -- Zen
    { "<leader>zm", function() Snacks.zen() end, desc = "󰾞 Toggle Zen Mode", },

    -- Lazygit
    { "<leader>lg", function() Snacks.lazygit.open() end, desc = " Open Lazygit", },
    { "<leader>ll", function() Snacks.lazygit.log() end, desc = " Lazygit log", },

    -- Notificiations
    { "<leader>nd", function() Snacks.notifier.hide() end, desc = "󰎟 Clear notifications", },
    { "<leader>nf", function() Snacks.picker.notifications() end, desc = " Search notifications", },
    { "<leader>ne", function() Snacks.picker.notifications({ filter = "error" }) end, desc = "󰎟 Show error notifications", },

    -- Explorer
    { "<leader>ee", function() Snacks.explorer.open() end, desc = " Open Snacks Explorer", },

    -- Buffer
    { "<leader>bd", function() Snacks.bufdelete() end, desc = " Delete current buffer (file or terminal)", },
    { "<leader>bo", function() Snacks.bufdelete.other() end, desc = " Delete other buffers", },

    -- LSP
    { "gr", function() Snacks.picker.lsp_references() end, desc = " Show LSP references", },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = " Go to declaration", },
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = " Show LSP definitions", },
    { "gi", function() Snacks.picker.lsp_implementations() end, desc = " Show LSP implementations", },
    { "gt", function() Snacks.picker.lsp_type_definitions() end, desc = " Show LSP type definitions", },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = " Show document symbols", },
    { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = " Show document symbols", },

    -- Search
    { "<leader>ff", function() Snacks.picker.files({ hidden = true }) end, desc = " Find files", },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = " Grep in workspace", },
    { mode = {"n", "v"}, "<leader>fw", function() Snacks.picker.grep_word() end, desc = " Grep in workspace", },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = " List open buffers", },

    -- Terminal
    { mode = { "n", "t" }, "<A-t>", function() Snacks.terminal.toggle() end, desc = "󰨚 Toggle floating terminal", },

    -- Git Pickers
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = " Git Status" },
    { "<leader>gL", function() Snacks.picker.git_log_file() end, desc = " Git Current File History" },

    -- Lists
    { "<leader>qf", function() Snacks.picker.qflist() end, desc = " Quickfix list" },
    { "<leader>ql", function() Snacks.picker.loclist() end, desc = " Loclist" },

    -- Diagnostics
    { "<leader>fd", function() Snacks.picker.diagnostics_buffer() end, desc = " Buffer diagnostics", },
    { "<leader>fD", function() Snacks.picker.diagnostics() end, desc = " Workspace diagnostics", },
    { "<leader>fT", function() Snacks.picker.todo_comments() end, desc = " Todo Comments", },

    -- Pickers
    { "<leader>fl", function() Snacks.picker.lsp_config() end, desc = " Lsp Config", },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "󰘥 Help Pages", },
    { "<leader>fM", function() Snacks.picker.man() end, desc = "󰘥 Man Pages", },
    { "<leader>fc", function() Snacks.picker.colorschemes() end, desc = " Colorscheme picker", },
    { "<leader>fi", function() Snacks.picker.icons({ icon_sources = { "nerd_fonts" } }) end, desc = "  Nerd Font Icons picker", },
    { "<leader>fm", function() Snacks.picker.marks() end, desc = " Marks" },
    { "<leader>fj", function() Snacks.picker.jumps() end, desc = "󰹹 Jumps" },
    { "<leader>fr", function() Snacks.picker.registers() end, desc = " Registers" },
    { "<leader>fP", function() Snacks.picker.projects() end, desc = " Projects" },
  },

	-- Setup toggle mappings
	config = function(_, opts)
		require("snacks").setup(opts)

		-- Custom highlight groups for dashboard elements
		vim.api.nvim_set_hl(0, "SnacksDashboardHeader", {
			fg = "#b16286",
			bold = true,
		})

		--    vim.api.nvim_set_hl(0, "SnacksDashboardDate", {
		--      fg = "#ebdbb2",
		--      bold = true
		--    })

		vim.api.nvim_set_hl(0, "SnacksDashboardIcon", {
			fg = "#d79921",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "SnacksDashboardKey", {
			fg = "#ebdbb2",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "SnacksDashboardDesc", {
			fg = "#ebdbb2",
		})

		local Snacks = require("snacks")

		Snacks.toggle.inlay_hints():map("<leader>uh", { desc = "󰅩 Toggle Inlay Hints" })
		Snacks.toggle.diagnostics():map("<leader>ud", { desc = " Toggle Diagnostics" })
		Snacks.toggle.line_number():map("<leader>uL", { desc = "󰨚 Toggle Line Numbers" })
		Snacks.toggle.treesitter():map("<leader>uT", { desc = "󱘎 Toggle Treesitter" })
		Snacks.toggle.dim():map("<leader>uD", { desc = " Toggle Dim Mode" })
		Snacks.toggle.animate():map("<leader>ua", { desc = "󰪐 Toggle Animations" })
		Snacks.toggle.indent():map("<leader>ui", { desc = "󰉶 Toggle Indent Guides" })
		Snacks.toggle.scroll():map("<leader>uS", { desc = "󰹹 Toggle Smooth Scroll" })

		Snacks.toggle.option("spell"):map("<leader>us", { desc = "󰓆 Spell Checking" })
		Snacks.toggle.option("wrap"):map("<leader>uw", { desc = "󰖶 Word Wrap" })
		Snacks.toggle.option("relativenumber"):map("<leader>ul", { desc = "󰉻 Relative Line Numbers" })

    --stylua: ignore
    Snacks.toggle.option("conceallevel", { name = " Conceal", off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
    --stylua: ignore
    Snacks.toggle.option("showtabline", { name = "󰓩 Tabline", off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2 }):map("<leader>ut")

		Snacks.toggle.zoom():map("<leader>sz", { desc = " Toggle Zoom Split" })
		Snacks.toggle.words():map("<leader>uW", { desc = "󰺯 Toggle Word Highlighting" })

		Snacks.toggle({
			name = "Auto Format (Global)",
			get = function()
				return not vim.g.disable_autoformat
			end,
			set = function(state)
				vim.g.disable_autoformat = not state
				vim.b.disable_autoformat = false
			end,
		}):map("<leader>uf")

		Snacks.toggle({
			name = "Auto Format (Buffer)",
			get = function()
				return not vim.b.disable_autoformat
			end,
			set = function(state)
				vim.b.disable_autoformat = not state
			end,
		}):map("<leader>uF")
	end,
}
