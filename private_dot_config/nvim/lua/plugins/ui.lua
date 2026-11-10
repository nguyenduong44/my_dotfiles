return {
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },
  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      opts.presets.lsp_doc_border = true
    end,
  },

  {
    "rcarriga/nvim-notify",
    opts = function(_, opts)
      local colors = require("solarized-osaka.colors").setup()
      opts.timeout = 5000
      opts.background_colour = colors.bg
      opts.render = "wrapped-compact"
    end,
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",

    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },

    opts = function(_, opts)
      local colors = require("solarized-osaka.colors").setup()

      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        -- mode = "tabs",

        indicator = {
          icon = "",
          style = "none",
        },

        separator_style = "thick",

        show_buffer_close_icons = false,
        show_close_icon = false,

        show_buffer_icons = true,
        color_icons = true,

        show_tab_indicators = false,
        always_show_bufferline = true,

        modified_icon = "[+]",
      })

      opts.highlights = {
        background = {
          bg = colors.none,
        },

        fill = {
          bg = colors.none,
        },

        buffer_selected = {
          bg = colors.none,
          fg = colors.yellow,
          bold = true,
        },

        buffer_visible = {
          bg = colors.none,
          fg = colors.base01,
        },

        tab = {
          bg = colors.none,
        },

        tab_selected = {
          bg = colors.none,
          fg = colors.yellow,
          bold = true,
        },

        separator = {
          bg = colors.none,
          fg = colors.none,
        },

        separator_selected = {
          bg = colors.none,
          fg = colors.none,
        },

        trunc_marker = {
          bg = colors.none,
        },
      }
    end,
  },

  -- filename
  {
    "b0o/incline.nvim",
    dependencies = {},
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local helpers = require("incline.helpers")
      local colors = require("solarized-osaka.colors").setup()
      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          local buffer = {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            {
              " " .. filename .. " ",
              guifg = colors.fg,
              guibg = colors.bg_highlight,
              gui = modified and "bold,italic" or "bold",
            },
          }
          return buffer
        end,
      })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    keys = {
      {
        ";c",
        ":LazyGit<Return>",
        silent = true,
        noremap = true,
      },
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[                 _                          ______  __ 
                | |                        / __   |/  |
 ____   ____  _ | |_   _  ___  ____   ____| | //| /_/ |
|  _ \ / _  |/ || | | | |/ _ \|  _ \ / _  | |// | | | |
| | | ( ( | ( (_| | |_| | |_| | | | ( ( | |  /__| | | |
|_| |_|\_|| |\____|\____|\___/|_| |_|\_|| |\_____/  |_|
      (_____|                       (_____|            ]],
        },
      },
    },
  },
}
