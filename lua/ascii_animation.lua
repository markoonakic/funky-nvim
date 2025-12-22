-- ASCII Dashboard Animation
local animation_started = false

local function start_animation()
	if animation_started or not _G.ascii_frames then
		return
	end

	animation_started = true

	vim.defer_fn(function() -- Wait 300ms for nvdash to fully render
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "nvdash" then
				local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

				print("[DEBUG] Buffer has " .. #lines .. " lines")
				print("[DEBUG] First 40 lines:")
				for i = 1, math.min(40, #lines) do
					print(string.format("  %2d: '%s' (len=%d)", i, lines[i], #lines[i]))
				end

				-- Find first button (first non-empty line)
				local first_button_line = nil
				for i, line in ipairs(lines) do
					if #line > 0 and line:match("%S") then
						first_button_line = i
						print("[DEBUG] Found first non-empty line at: " .. i)
						break
					end
				end

				if not first_button_line then
					print("[ERROR] Could not find buttons - buffer might be empty or not rendered yet")
					return
				end

				-- Header should end just before buttons (with 1 line gap)
				local header_start = first_button_line - 23
				if header_start < 0 then
					header_start = 0
				end

				print("[INFO] First button at line " .. first_button_line .. ", rendering animation at line " .. header_start)

				-- Render first frame immediately
				vim.bo[buf].modifiable = true
				vim.api.nvim_buf_set_lines(buf, header_start, header_start + 22, false, _G.ascii_frames[1])

				-- Apply pink highlight
				local ns = vim.api.nvim_create_namespace("ascii_anim")
				for i = 0, 21 do
					vim.api.nvim_buf_add_highlight(buf, ns, "NvDashAscii", header_start + i, 0, -1)
				end

				vim.bo[buf].modifiable = false

				-- Start animation timer
				local timer = vim.loop.new_timer()
				local frame = 2

				timer:start(40, 40, vim.schedule_wrap(function()
					if not vim.api.nvim_buf_is_valid(buf) then
						timer:stop()
						animation_started = false
						return
					end

					vim.bo[buf].modifiable = true
					vim.api.nvim_buf_set_lines(buf, header_start, header_start + 22, false, _G.ascii_frames[frame])

					-- Reapply highlight
					for i = 0, 21 do
						vim.api.nvim_buf_add_highlight(buf, ns, "NvDashAscii", header_start + i, 0, -1)
					end

					vim.bo[buf].modifiable = false

					frame = frame % #_G.ascii_frames + 1
				end))

				print("[SUCCESS] Animation started!")
				return
			end
		end
	end, 100)
end

-- Start when nvdash opens
vim.api.nvim_create_autocmd("FileType", {
	pattern = "nvdash",
	callback = start_animation,
})
