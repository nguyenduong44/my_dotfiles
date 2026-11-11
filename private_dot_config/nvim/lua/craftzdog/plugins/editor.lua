-- Completion
require("blink.cmp").setup({
	snippets = {
		preset = "default",
	},
	completion = {
		accept = {
			auto_brackets = {
				enabled = true,
			},
		},
		menu = {
			border = "none",
			draw = {
				treesitter = { "lsp" },
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
		ghost_text = {
			enabled = false,
		},
	},

	cmdline = {
		enabled = true,
		keymap = {
			preset = "cmdline",
			["<Right>"] = false,
			["<Left>"] = false,
		},
		completion = {
			list = { selection = { preselect = false } },
			menu = {
				auto_show = function(ctx)
					return vim.fn.getcmdtype() == ":"
				end,
			},
			ghost_text = { enabled = true },
		},
	},

	keymap = {
		preset = "enter",
		["c-y"] = { "select_and_accept" },
	},

	appearance = {
		kind_icons = Craftzdog.icons.kinds,
	},
})

-- Pairs
require("mini.pairs").setup({
	modes = { insert = true, command = true, terminal = false },
})

-- Git
require("mini.diff").setup({
	view = {
		-- show whole reference part above whole buffer part, as in `git diff`
		overlay_style = "hunk",
	},
	mappings = {
		goto_next = "]c",
		goto_prev = "[c",
	},
})

require("gitsigns").setup()
require("gitlinker").setup()

-- File explorer
require("oil").setup({
	default_file_explorer = true,
	columns = {
		"icon",
		"permissions",
		"size",
		"mtime",
	},
	view_options = {
		show_hidden = true,
	},
	lsp_file_methods = {
		enabled = true,
		autosave_changes = true,
	},
	float = {
		padding = 2,
		max_width = 200,
		border = "rounded",
	},
	keymaps = {
		["h"] = "actions.parent",
		["q"] = "actions.close",
	},
})

-- Comments
require("todo-comments").setup()

-- Formatting
local oxfmtFormatter = { "oxfmt", "prettierd", "prettier", stop_after_first = true }
require("conform").setup({
	default_format_opts = {
		timeout_ms = 1000,
		async = false,
		quiet = false,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		javascript = oxfmtFormatter,
		typescript = oxfmtFormatter,
		javascriptreact = oxfmtFormatter,
		typescriptreact = oxfmtFormatter,
		json = oxfmtFormatter,
		css = oxfmtFormatter,
		html = oxfmtFormatter,
		markdown = oxfmtFormatter,
		yaml = oxfmtFormatter,
		less = oxfmtFormatter,
		scss = oxfmtFormatter,
		["markdown.mdx"] = oxfmtFormatter,
		mdx = oxfmtFormatter,
		lua = { "stylua" },
		sh = { "shfmt" },
		fish = { "fish_indent" },
	},
	formatters = {
		oxfmt = {
			-- Treat oxfmt as available only when the project has an oxfmt config
			-- (.oxfmtrc.json / .oxfmtrc.jsonc / vite.config.ts). Without it, oxfmt is
			-- skipped and the formatter list falls back to prettierd/prettier.
			require_cwd = true,
		},
	},
	format_on_save = function(bufnr)
		if vim.b[bufnr].disable_autoformat then
			return
		end
		return {
			timeout_ms = 1000,
			lsp_format = "fallback",
		}
	end,
})

-- Colors
vim.lsp.document_color.enable(false)
require("nvim-highlight-colors").setup({
	render = "background",
	enable_hex = true,
	enable_short_hex = true,
	enable_rgb = true,
	enable_hsl = true,
	enable_hsl_without_function = true,
	enable_ansi = true,
	enable_var_usage = true,
	enable_tailwind = false,
})
