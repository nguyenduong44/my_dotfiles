vim.pack.add({
	{ src = "https://github.com/rachartier/tiny-cmdline.nvim" },
	{ src = "https://github.com/craftzdog/solarized-osaka.nvim" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/b0o/incline.nvim" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
	{ src = "https://github.com/brenoprata10/nvim-highlight-colors" },
	-- LSP
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	-- Completion
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	-- Pairs & Formatting
	{ src = "https://github.com/nvim-mini/mini.pairs" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	-- Git
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/craftzdog/mini.diff", version = "feat/grouping" },
	{ src = "https://github.com/esmuellert/codediff.nvim" },
	{ src = "https://github.com/linrongbin16/gitlinker.nvim" },
	-- AI
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
})

require("craftzdog.plugins.ui")
require("craftzdog.plugins.treesitter")
require("craftzdog.plugins.editor")
require("craftzdog.plugins.lsp")
require("craftzdog.plugins.util")
require("craftzdog.plugins.keymaps")
