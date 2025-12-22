-- put this in your main init.lua file ( before lazy setup )
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

require("config")
require("core.lazy")

-- put this after lazy setup

-- (method 2, for non lazyloaders) to load all highlights at once
local cache = vim.g.base46_cache

-- if cache dir is missing or empty, build it once so new devcontainers work
local ok_base46, base46 = pcall(require, "base46")
if ok_base46 and (vim.fn.isdirectory(cache) == 0 or #vim.fn.readdir(cache) == 0) then
	base46.load_all_highlights()
end

if vim.fn.isdirectory(cache) == 1 then
	for _, v in ipairs(vim.fn.readdir(cache)) do
		dofile(cache .. "/" .. v)
	end
end

-- Load ASCII dashboard animation
require("ascii_animation")
