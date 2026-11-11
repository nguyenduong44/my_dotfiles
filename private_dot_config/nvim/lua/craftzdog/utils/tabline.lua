local M = {}

local function format_name(name)
	if vim.fn.strchars(name) > 20 then
		return vim.fn.strcharpart(name, 0, 17) .. "…"
	end
	return name
end

local function format_oil_path(dir)
	local home = vim.fn.expand("~")
	if dir:find(home, 1, true) == 1 then
		dir = "~" .. dir:sub(#home + 1)
	end
	dir = dir:gsub("/$", "")
	if vim.fn.strchars(dir) > 20 then
		return "…" .. vim.fn.strcharpart(dir, vim.fn.strchars(dir) - 17, 17)
	end
	return dir
end

function M.setup_highlights()
	local ok, colors_mod = pcall(require, "solarized-osaka.colors")
	if not ok or not colors_mod then
		return
	end

	local ok_colors, colors = pcall(colors_mod.setup)
	if not ok_colors or not colors then
		return
	end

	vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "TabLineSel", { fg = colors.base4, bg = colors.yellow, bold = true })
	vim.api.nvim_set_hl(0, "TabLineSelSep", { fg = colors.yellow, bg = "NONE" })
	vim.api.nvim_set_hl(0, "TabLine", { fg = colors.base0, bg = colors.base02 })
	vim.api.nvim_set_hl(0, "TabLineSep", { fg = colors.base02, bg = "NONE" })
end

function M.render()
	local tabpages = vim.api.nvim_list_tabpages()
	if #tabpages < 2 then
		return ""
	end

	local current_tab = vim.api.nvim_get_current_tabpage()
	local s = ""

	for i, tab in ipairs(tabpages) do
		local is_active = (tab == current_tab)
		local win = vim.api.nvim_tabpage_get_win(tab)
		local buf = vim.api.nvim_win_get_buf(win)
		local buftype = vim.bo[buf].buftype
		local bufname = vim.api.nvim_buf_get_name(buf)
		local modified = vim.bo[buf].modified

		local name, icon
		if buftype == "terminal" then
			name = "[Terminal]"
			icon = ""
		elseif vim.bo[buf].filetype == "oil" or bufname:match("^oil://") then
			local ok_oil, oil = pcall(require, "oil")
			local raw_dir = (ok_oil and oil.get_current_dir(buf)) or bufname:gsub("^oil://", "")
			name = format_oil_path(raw_dir)
			icon = ""
		elseif bufname == "" then
			name = "[No Name]"
			icon = ""
		else
			name = format_name(vim.fn.fnamemodify(bufname, ":t"))
			local ok, mini_icons = pcall(require, "mini.icons")
			if ok then
				icon = mini_icons.get("file", name)
			else
				icon = ""
			end
		end

		local hl_sep = is_active and "%#TabLineSelSep#" or "%#TabLineSep#"
		local hl_tab = is_active and "%#TabLineSel#" or "%#TabLine#"

		local content_parts = {}
		if modified then
			table.insert(content_parts, "[+]")
		end
		if icon and icon ~= "" then
			table.insert(content_parts, icon)
		end
		table.insert(content_parts, name)
		local content = table.concat(content_parts, " ")

		s = s .. "%" .. i .. "T"
		s = s .. hl_sep .. ""
		s = s .. hl_tab .. "   " .. content .. "   "
		s = s .. hl_sep .. ""
		s = s .. "%T"
	end

	s = s .. "%#TabLineFill#%="
	return s
end

function M.setup()
	M.setup_highlights()
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = M.setup_highlights,
	})
	vim.opt.showtabline = 1
	vim.opt.tabline = "%!v:lua.Craftzdog.tabline.render()"
end

M.setup()

return M
