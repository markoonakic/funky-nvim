return {
	"leath-dub/snipe.nvim",
	event = { "BufReadPre" },
	opts = {},
  -- stylua: ignore
  keys = {
    { "<leader>bs", function() require("snipe").open_buffer_menu() end, desc = " Open Snipe buffer menu", },
  },
}
