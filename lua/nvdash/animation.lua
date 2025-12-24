-- ASCII Dashboard Animation using Extmarks
-- Works with nvdash's virtual text rendering system

-- Configuration constants
local ANIMATION_FPS = 15
local FRAME_INTERVAL_MS = math.floor(1000 / ANIMATION_FPS) -- 66ms
local EXTMARK_PRIORITY = 50000
local STARTUP_DELAY_MS = 0  -- MAXIMUM SPEED MODE!
local RESIZE_REQUERY_DELAY_MS = 50

local M = {}

local function start_animation(buf)
	-- Prevent multiple animations
	if _G.ascii_animation_running then
		return
	end

	-- Validate frames are loaded
	if not _G.ascii_frames or #_G.ascii_frames == 0 then
		print("[ERROR] ASCII frames not loaded")
		return
	end

	_G.ascii_animation_running = true

	-- Get window reference
	local win = vim.g.nvdash_win
	if not win or not vim.api.nvim_win_is_valid(win) then
		print("[ERROR] nvdash window not found")
		_G.ascii_animation_running = false
		return
	end

	-- Find nvdash's header extmarks to get position
	local ns_nvdash = vim.api.nvim_create_namespace("nvdash")
	local extmarks = vim.api.nvim_buf_get_extmarks(buf, ns_nvdash, 0, -1, { details = true })

	local header_start_row = nil
	for _, mark in ipairs(extmarks) do
		local details = mark[4]
		if details.virt_text and details.virt_text[1] and details.virt_text[1][2] == "NvDashAscii" then
			header_start_row = mark[2] -- 0-indexed row
			break
		end
	end

	if not header_start_row then
		print("[ERROR] Could not find nvdash header position - no extmarks with NvDashAscii highlight")
		_G.ascii_animation_running = false
		return
	end

	-- Create our animation namespace (use very high priority to overlay nvdash)
	local ns_anim = vim.api.nvim_create_namespace("ascii_animation")

	-- Get window dimensions for centering
	local winw = vim.api.nvim_win_get_width(win)

	-- Animation state
	local current_frame_idx = 1
	local total_frames = #_G.ascii_frames
	local timer = vim.loop.new_timer()

	-- Function to update extmarks with current frame
	local function update_frame()
		if not vim.api.nvim_buf_is_valid(buf) then
			timer:stop()
			timer:close()
			_G.ascii_animation_running = false
			return
		end

		if vim.bo[buf].filetype ~= "nvdash" then
			timer:stop()
			timer:close()
			_G.ascii_animation_running = false
			return
		end

		local frame = _G.ascii_frames[current_frame_idx]

		-- Update all 22 lines with VERY high priority (don't clear nvdash extmarks)
		local ok, err = pcall(function()
			for i = 1, 22 do
				local line_text = frame[i]
				local row = header_start_row + (i - 1)

				-- Calculate horizontal centering (same as nvdash does)
				local col = math.floor((winw / 2) - math.floor(vim.api.nvim_strwidth(line_text) / 2)) - 6

				-- Update extmark with very high priority to always overlay
				vim.api.nvim_buf_set_extmark(buf, ns_anim, row, 0, {
					id = i,
					virt_text = { { line_text, "NvDashAscii" } },
					virt_text_win_col = col,
					priority = EXTMARK_PRIORITY,
				})
			end
		end)

		if not ok then
			print("[ERROR] Failed to update extmarks: " .. tostring(err))
			timer:stop()
			timer:close()
			_G.ascii_animation_running = false
			return
		end

		-- Advance to next frame
		current_frame_idx = (current_frame_idx % total_frames) + 1
	end

	-- Start animation timer
	timer:start(
		0, -- Start immediately
		FRAME_INTERVAL_MS,
		vim.schedule_wrap(update_frame)
	)

	-- Cleanup on buffer close
	vim.api.nvim_create_autocmd("BufWinLeave", {
		buffer = buf,
		callback = function()
			if timer then
				timer:stop()
				timer:close()
			end
			vim.api.nvim_buf_clear_namespace(buf, ns_anim, 0, -1)
			_G.ascii_animation_running = false
		end,
		once = true,
	})

	-- Also cleanup on buffer delete
	vim.api.nvim_create_autocmd("BufDelete", {
		buffer = buf,
		callback = function()
			if timer then
				timer:stop()
				timer:close()
			end
			_G.ascii_animation_running = false
		end,
		once = true,
	})

	-- Handle window resize
	vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
		buffer = buf,
		callback = function()
			-- Update window width
			if vim.api.nvim_win_is_valid(win) then
				winw = vim.api.nvim_win_get_width(win)
			end

			-- Re-query nvdash's header position (it redraws on resize)
			vim.defer_fn(function()
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end

				local marks = vim.api.nvim_buf_get_extmarks(buf, ns_nvdash, 0, -1, { details = true })
				for _, mark in ipairs(marks) do
					local details = mark[4]
					if details.virt_text and details.virt_text[1] and details.virt_text[1][2] == "NvDashAscii" then
						header_start_row = mark[2]
						break
					end
				end
			end, RESIZE_REQUERY_DELAY_MS)
		end,
	})
end

-- Start animation when nvdash opens
vim.api.nvim_create_autocmd("FileType", {
	pattern = "nvdash",
	callback = function(ev)
		local buf = ev.buf

		-- Defer to ensure nvdash has rendered its extmarks
		vim.defer_fn(function()
			if vim.api.nvim_buf_is_valid(buf) then
				start_animation(buf)
			end
		end, STARTUP_DELAY_MS)
	end,
})

return M
