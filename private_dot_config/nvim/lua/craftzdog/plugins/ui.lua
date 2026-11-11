-- Colorscheme
require("solarized-osaka").setup({
	style = "vivid",
	transparent = true,
	styles = {
		sidebars = "transparent",
		floats = "transparent",
	},
})
vim.cmd.colorscheme("solarized-osaka")

-- Icons
require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()

-- Floating Cmdline
require("tiny-cmdline").setup({
	position = {
		x = "50%",
		y = "20%",
	},
})

-- Statusline
local project_markers = {
	".git",
	"lua",
	"package.json",
	"Makefile",
	"Cargo.toml",
	"go.mod",
	"pyproject.toml",
}

require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			-- Project root name (only when it differs from cwd)
			{
				function()
					local bufpath = vim.api.nvim_buf_get_name(0)
					local root = vim.fs.root(bufpath ~= "" and bufpath or 0, project_markers)
					local cwd = vim.fn.getcwd()
					if root and root ~= cwd then
						return vim.fs.basename(root)
					end
					return ""
				end,
				icon = "󰉓",
				separator = "",
			},
			-- filetype icon
			{
				"filetype",
				icon_only = true,
				separator = "",
				padding = { left = 1, right = 0 },
			},
			-- pretty path
			{
				function()
					local path = vim.fn.expand("%:p")
					if path == "" then
						return ""
					end
					local cwd = vim.fn.getcwd()
					local root = vim.fs.root(0, project_markers) or cwd

					if path:find(cwd, 1, true) == 1 then
						path = path:sub(#cwd + 2)
					elseif path:find(root, 1, true) == 1 then
						path = path:sub(#root + 2)
					end

					local parts = vim.split(path, "[/\\]")
					local length = 3
					if #parts > length then
						parts = { parts[1], "...", unpack(parts, #parts - length + 2) }
					end

					return table.concat(parts, "/")
				end,
			},
		},
		lualine_x = {
			-- Macro recording register
			{
				function()
					local reg = vim.fn.reg_recording()
					if reg == "" then
						return ""
					end
					return "Recording @" .. reg
				end,
			},
			{ "diagnostics" },
			{ "diff" },
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- Refreshes lualine on cursor move and macro start/stop
local lualine_group = vim.api.nvim_create_augroup("craftzdog_lualine", { clear = true })
local function refresh_lualine()
	local ok, lualine = pcall(require, "lualine")
	if ok then
		lualine.refresh({ place = { "statusline" } })
	end
end

vim.api.nvim_create_autocmd("RecordingEnter", {
	group = lualine_group,
	callback = refresh_lualine,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
	group = lualine_group,
	callback = function()
		vim.defer_fn(refresh_lualine, 50)
	end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	group = lualine_group,
	callback = refresh_lualine,
})

-- Window labels (Incline)
local ok_osaka, osaka_colors = pcall(require, "solarized-osaka.colors")
local colors = ok_osaka and osaka_colors.setup() or {}

require("incline").setup({
	highlight = {
		groups = {
			InclineNormal = {
				guibg = colors.magenta500 or "#fe67a8",
				guifg = colors.base04 or "#001419",
			},
			InclineNormalNC = {
				guifg = colors.violet500 or "#9498ea",
				guibg = colors.base03 or "#002c38",
			},
		},
	},
	window = { margin = { vertical = 0, horizontal = 1 } },
	hide = { cursorline = true },
	render = function(props)
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if filename == "" then
			filename = "[No Name]"
		end
		local ok_devicons, devicons = pcall(require, "nvim-web-devicons")
		local icon, color = "", nil
		if ok_devicons then
			icon, color = devicons.get_icon_color(filename)
		end
		if vim.bo[props.buf].modified then
			filename = "[+] " .. filename
		end
		return {
			{ (icon or "") .. " ", guifg = color },
			{ filename },
		}
	end,
})

-- Snacks
local lazygit_utils = require("craftzdog.utils.lazygit")
require("snacks").setup({
	notifier = { enabled = true },
	indent = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	scroll = { enabled = false },
	picker = {
		enabled = true,
		jump = {
			reuse_win = true,
		},
		sources = {
			files = {
				hidden = true,
				ignored = true,
				exclude = { "node_modules", ".git/objects", ".git/hooks" },
			},
			grep = {
				hidden = true,
				ignored = true,
				exclude = { "node_modules", ".git/objects", ".git/hooks" },
			},
		},
	},
	lazygit = {
		enabled = true,
		configure = true,
		config = {
			os = {
				edit = lazygit_utils.edit_command(),
				editAtLine = lazygit_utils.edit_command({ at_line = true }),
			},
		},
		theme = {
			activeBorderColor = { fg = "WarningMsg", bold = true },
		},
	},
})

-- Allow finding .git files (worktrees, .git/config, etc.) without dumping internal objects
local ok_files_src, files_src = pcall(require, "snacks.picker.source.files")
if ok_files_src and files_src.get_cmd then
	local _, commands = debug.getupvalue(files_src.get_cmd, 1)
	if type(commands) == "table" then
		for _, cmd_def in ipairs(commands) do
			if type(cmd_def.args) == "table" then
				for i = #cmd_def.args, 1, -1 do
					if cmd_def.args[i] == ".git" and cmd_def.args[i - 1] == "-E" then
						table.remove(cmd_def.args, i)
						table.remove(cmd_def.args, i - 1)
						table.insert(cmd_def.args, "-E")
						table.insert(cmd_def.args, ".git/objects")
						break
					elseif cmd_def.args[i] == "!.git" and cmd_def.args[i - 1] == "-g" then
						cmd_def.args[i] = "!.git/objects"
						break
					end
				end
			end
		end
	end
end

-- Codediff
require("codediff").setup({
	explorer = {
		width = 50,
		auto_open_on_cursor = true,
		view_mode = "tree",
		line_stats = {
			enabled = true,
		},
	},
	diff = {
		compact = true,
		compact_context_lines = 8,
		compact_sync_folds = true,
	},
	keymaps = {
		view = {},
	},
})
