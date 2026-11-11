local yank_group = vim.api.nvim_create_augroup("craftzdog_yank_highlight", { clear = true })
local cursorline_group = vim.api.nvim_create_augroup("craftzdog_cursorline", { clear = true })

-- Yanked text flashes briefly
vim.api.nvim_create_autocmd("TextYankPost", {
	group = yank_group,
	callback = function()
		vim.hl.on_yank({ timeout = 200 })
	end,
})

-- Only the active window shows the cursorline
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = cursorline_group,
	callback = function()
		if vim.api.nvim_win_get_config(0).relative == "" then
			vim.opt_local.cursorline = true
		end
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
	group = cursorline_group,
	callback = function()
		if vim.api.nvim_win_get_config(0).relative == "" then
			vim.opt_local.cursorline = false
		end
	end,
})
