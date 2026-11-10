return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        -- Ghi đè phím Enter để luôn mở file sang Vim Tabpage mới
        ["<cr>"] = "open_tabnew",
      },
    },
  },
}
