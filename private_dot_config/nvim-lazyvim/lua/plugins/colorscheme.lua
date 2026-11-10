return {
  {
    "craftzdog/solarized-osaka.nvim",

    lazy = false,
    priority = 1000,

    opts = {
      transparent = true,
      terminal_colors = true,

      styles = {
        comments = {
          italic = true,
        },

        keywords = {
          italic = true,
        },

        functions = {},
        variables = {},

        sidebars = "dark",
        floats = "dark",
      },

      vivid_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,

      on_colors = function(c)
        -- Because lualine broke stuff with the latest commit
        c.bg_statusline = c.none
      end,
      on_highlights = function(hl, c)
        -- TabLineFill is currently set to black
        hl.TabLineFill = {
          bg = c.none,
        }
      end,
    },

    config = function(_, opts)
      require("solarized-osaka").setup(opts)

      vim.cmd.colorscheme("solarized-osaka-vivid")
    end,
  },
}
