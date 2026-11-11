-- Delete without copying
vim.keymap.set({ "n", "x" }, "x", '"_x')

-- Delete, change, and paste without touching the yank register
vim.keymap.set({ "n", "x" }, "<leader>d", '"_d')
vim.keymap.set({ "n", "x" }, "<leader>c", '"_c')
vim.keymap.set("n", "<leader>p", '"0p')
vim.keymap.set("x", "<leader>p", '"_dP')

-- Delete word backwards without copying
vim.keymap.set("n", "dw", 'vb"_d')

-- Increment and decrement numbers
vim.keymap.set("n", "+", "<C-a>")
vim.keymap.set("n", "-", "<C-x>")

-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G")

-- Tabs
vim.keymap.set("n", "te", ":tabedit<Return>")
vim.keymap.set("n", "<Tab>", ":tabnext<Return>")
vim.keymap.set("n", "<S-Tab>", ":tabprev<Return>")
vim.keymap.set("n", "tw", ":tabclose<Return>")

-- Splits
vim.keymap.set("n", "ss", ":split<Return>")
vim.keymap.set("n", "sv", ":vsplit<Return>")

-- Move between windows
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sl", "<C-w>l")

-- Resize window
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Jump list forward
vim.keymap.set("n", "<C-m>", "<C-i>")

-- Open line without continuing comment
vim.keymap.set("n", "<leader>o", "o<Esc>^Da")
vim.keymap.set("n", "<leader>O", "O<Esc>^Da")

-- Close hidden buffers except unsaved ones
vim.keymap.set("n", "<leader>bd", function()
	Craftzdog.editor.close_hidden_buffers()
end, { desc = "Close hidden buffers" })

-- Yank path with line number (relative / absolute)
vim.keymap.set("n", "<leader>yf", function()
	Craftzdog.editor.yank_relative_path_with_line()
end, { desc = "Yank relative path with line number" })

vim.keymap.set("n", "<leader>yp", function()
	Craftzdog.editor.yank_absolute_path_with_line()
end, { desc = "Yank absolute path with line number" })

-- Copy visual selection as Markdown codeblock with filename and line number
vim.keymap.set(
	"v",
	"<leader>cc",
	":<C-u>lua Craftzdog.editor.copy_as_codeblock()<CR>",
	{ desc = "Copy selection as Markdown codeblock" }
)

-- Open package.json in centered floating window
vim.keymap.set("n", "<leader>j", function()
	Craftzdog.editor.open_package_json()
end, { desc = "Open package.json in floating window" })
