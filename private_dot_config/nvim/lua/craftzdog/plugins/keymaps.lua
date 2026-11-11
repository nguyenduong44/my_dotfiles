-- Snacks.words
vim.keymap.set({ "n", "t" }, "]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })

vim.keymap.set({ "n", "t" }, "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Prev reference" })

-- Snacks.picker
vim.keymap.set("n", ";f", function()
	Snacks.picker.files({
		hidden = true,
		ignored = true,
		exclude = { "node_modules", ".git/objects", ".git/hooks" },
	})
end, { desc = "Find files (hidden & ignored)" })

vim.keymap.set("n", ";r", function()
	Snacks.picker.grep({
		hidden = true,
		ignored = true,
		exclude = { "node_modules", ".git/objects", ".git/hooks" },
	})
end, { desc = "Live grep (hidden & ignored)" })

vim.keymap.set("n", ";;", function()
	Snacks.picker.resume()
end, { desc = "Resume last picker" })

vim.keymap.set("n", "\\\\", function()
	Snacks.picker.buffers({ jump = { reuse_win = true } })
end, { desc = "Open buffers (reuse win)" })

vim.keymap.set("n", ";e", function()
	Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })

vim.keymap.set("n", ";n", function()
	Snacks.picker.notifications()
end, { desc = "Notification history" })

vim.keymap.set("n", ";h", function()
	Snacks.picker.git_diff()
end, { desc = "Git hunks" })

-- Oil.nvim
vim.keymap.set("n", "sf", function()
	require("oil").open_float(nil, { preview = {} })
end, { desc = "Open oil float with preview" })

-- LSP Keymaps (Step 5.7)
vim.keymap.set("n", "gd", function()
	Snacks.picker.lsp_definitions({ jump = { reuse_win = false } })
end, { desc = "Goes to the definition" })

vim.keymap.set("n", "gD", function()
	Snacks.picker.lsp_declarations()
end, { desc = "Goes to the declaration" })

vim.keymap.set("n", "gy", function()
	Snacks.picker.lsp_type_definitions()
end, { desc = "Goes to the type definition" })

vim.keymap.set("n", "gr", function()
	Snacks.picker.lsp_references()
end, { desc = "Lists references" })

vim.keymap.set("n", "gI", function()
	local clients = vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })
	if #clients > 0 then
		local params = vim.lsp.util.make_position_params(0, "utf-16")
		clients[1]:request("workspace/executeCommand", {
			command = "typescript.goToSourceDefinition",
			arguments = { params.textDocument.uri, params.position },
		}, function(err, result)
			if err then
				vim.notify("goToSourceDefinition: " .. err.message, vim.log.levels.ERROR)
				return
			end
			if result and #result > 0 then
				vim.lsp.util.show_document(result[1], "utf-16", { focus = true })
			else
				vim.notify("No source definition found", vim.log.levels.INFO)
			end
		end, 0)
	else
		vim.lsp.buf.implementation()
	end
end, { desc = "Goes to source definition / implementation" })

vim.keymap.set("n", ";c", function()
	Snacks.picker.lsp_incoming_calls()
end, { desc = "Lists incoming calls" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Shows hover docs" })
vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Show signature help" })
vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Show signature help" })

vim.keymap.set("n", "<c-j>", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Jumps to next diagnostic with a float" })

vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Shows code actions" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Renames the symbol" })

vim.keymap.set("n", "<leader>cR", function()
	Snacks.rename.rename_file()
end, { desc = "Renames the file with import updates" })

vim.keymap.set({ "n", "x" }, "<leader>f", function()
	require("conform").format()
end, { desc = "Formats now" })

vim.keymap.set("n", "<leader>cl", function()
	Snacks.picker.lsp_config()
end, { desc = "Shows LSP info" })

-- Git (Step 6.1 & 6.2)
vim.keymap.set("n", "<leader>gb", function()
	require("gitsigns").blame_line()
end, { desc = "Blames the line" })

vim.keymap.set("n", "<leader>gB", function()
	require("gitsigns").blame()
end, { desc = "Blames the buffer" })

vim.keymap.set("n", "<leader>go", function()
	local async = require("gitsigns.async")
	local cache = require("gitsigns.cache").cache

	async.run(function()
		local bufnr = vim.api.nvim_get_current_buf()
		local lnum = vim.api.nvim_win_get_cursor(0)[1]
		local bcache = cache[bufnr]
		if not bcache then
			return
		end

		bcache:get_blame(lnum)
		local blame = bcache.blame
		if not blame or not blame.entries or not blame.entries[lnum] then
			return
		end

		local info = blame.entries[lnum]
		local sha = info.commit.sha

		-- Check if uncommitted (sha is all zeros)
		if tonumber("0x" .. sha:sub(1, 8)) == 0 then
			vim.notify("Line not committed yet", vim.log.levels.WARN)
			return
		end

		vim.cmd.tabnew()
		require("gitsigns.actions.diffthis").show(bufnr, sha, info.filename)
		async.schedule()
		pcall(vim.api.nvim_win_set_cursor, 0, { info.orig_lnum or lnum, 0 })
	end)
end, { desc = "Opens file as of last commit touching line in new tab" })

vim.keymap.set("n", "<leader>gs", function()
	local gs = require("gitsigns")
	if #(gs.get_hunks() or {}) > 0 then
		gs.stage_buffer()
	else
		gs.reset_buffer_index()
	end
end, { desc = "Stages buffer, or unstages if nothing left to stage" })

vim.keymap.set("n", "<leader>gh", function()
	require("gitsigns").stage_hunk()
end, { desc = "Stages or unstages the hunk" })

vim.keymap.set("n", "<leader>gd", function()
	local MiniDiff = require("mini.diff")
	MiniDiff.toggle_overlay()
end, { desc = "Toggles the diff overlay" })

-- Lazygit (Step 6.4)
vim.keymap.set("n", ";g", function()
	require("craftzdog.utils.lazygit").open()
end, { desc = "Lazygit" })

-- CodeDiff (Step 6.3)
vim.keymap.set("n", "<leader>dv", "<cmd>CodeDiff<cr>", { desc = "Toggles the diff view" })
vim.keymap.set("n", "<leader>dh", "<cmd>CodeDiff history %<cr>", { desc = "Shows the current file's history" })
vim.keymap.set("n", "<leader>dH", "<cmd>CodeDiff history<cr>", { desc = "Shows the repo history" })
