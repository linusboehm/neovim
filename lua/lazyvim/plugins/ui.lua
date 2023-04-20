return {
  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Delete all Notifications",
      },
    },
    opts = function()
      local icons = require("lazyvim.config").icons
      return {
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
        icons = {
          ERROR = icons.diagnostics.Error,
          WARN = icons.diagnostics.Warn,
          INFO = icons.diagnostics.Info,
          DEBUG = icons.diagnostics.Hint,
          TRACE = icons.diagnostics.Hint,
        }
      }
    end,
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      local Util = require("lazyvim.util")
      if not Util.has("noice.nvim") then
        Util.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
    end,
  },

  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        -- numbers = function(opts)
        --   return string.format('%s', opts.raise(opts.id))
        -- end,
        separator_style = "thick",
        tab_size = 5,
        left_trunc_marker = '<',
        right_trunc_marker = '..',
        diagnostics_indicator = function(_, _, diag)
          local icons = require("lazyvim.config").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            -- highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = require("lazyvim.config").icons

      -- local function fg(name)
      --   return function()
      --     ---@type {foreground?:number}?
      --     local hl = vim.api.nvim_get_hl_by_name(name, true)
      --     return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
      --   end
      -- end

      return {
        options = {
          icons_enabled = false,
          theme = "auto",
          disabled_filetypes = { statusline = { "dashboard", "alpha", "toggleterm" } },
          ignore_focus = { "neo-tree", "toggleterm" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            {
              function()
                return "⎇ "
              end,
              separator = "",
              padding = { left = 1, right = 0 },
            },
            {
              "branch",
              separator = "‖",
            },
            { "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              separator = "‖",
            },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_c = {
            {
              "filename",
              path = 1,
              symbols = { modified = icons.git.modified, readonly = "", unnamed = "" },
              separator = "‖"
            },
          },
          lualine_x = { "searchcount" },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return "⏱ " .. os.date("%R")
            end,
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },

  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- char = "▏",
      char = "│",
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },

  -- get super slow for large files -> disable
 -- -- active indent guide and indent text objects
 -- {
 --   "echasnovski/mini.indentscope",
 --   version = false, -- wait till new 0.7.0 release to put it back on semver
 --   event = { "BufReadPre", "BufNewFile" },
 --   opts = {
 --     -- symbol = "▏",
 --     symbol = "│",
 --     options = { try_as_border = true },
 --   },
 --   init = function()
 --     vim.api.nvim_create_autocmd("FileType", {
 --       pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
 --       callback = function()
 --         vim.b.miniindentscope_disable = true
 --       end,
 --     })
 --   end,
 --   config = function(_, opts)
 --     require("mini.indentscope").setup(opts)
 --   end,
 -- },

  -- noicer ui
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      -- which key integration
      {
        "folke/which-key.nvim",
        opts = function(_, opts)
          if require("lazyvim.util").has("noice.nvim") then
            opts.defaults["<leader>sn"] = { name = "+noice" }
          end
        end,
      },
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
      cmdline = {
        format = {
          cmdline = { icon = ">_" },
          search_down = { icon = "/" },
          search_up = { icon = "?" },
          filter = { icon = "$" },
          lua = { icon = "☾" },
          help = { icon = "?" },
        },
      },
      format = {
        level = {
          icons = {
            error = "✖",
            warn = "‼",
            info = "🛈 ",
          }
        },
      },
      routes = {
        { filter = { event = "msg_show", find = "search hit BOTTOM" }, skip = true },
        { filter = { event = "msg_show", find = "search hit TOP" }, skip = true },
        { filter = { event = "notify", find = "# Config Change Detected" }, skip = true },
        -- { filter = { event = "msg_show", find = "E486: Pattern not found:" }, stop = true },
        { filter = { event = "msg_show", find = "E486: Pattern not found:" }, view = 'mini' },
        { filter = { event = "msg_show", kind = "search_count", }, skip = true },
      }
    },
    -- stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      -- { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
      -- { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    },
  },

  -- dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
            local logo = [[
                    ███████
                  ██░░░░░░░██
                ██░░░░░░░░░░░█
    ██          █░░░░░░░░██░░█████████
  ██░░█         █░░░░░░░░░░░░█▒▒▒▒▒▒█
  █░░░░██       ██░░░░░░░░░░░████████
 █░░░░░░░█        █░░░░░░░░░█
█░░░░░░░░░██████████░░░░░░░█
█░░░░░░░░░░░░░░░░░░░░░░░░░░░██
█░░░░░░░░░░░░░░░░█░░░░░░░░░░░░█
██░░░░░░░░█░░░░░░░██░░░░░░░░░░█
  █░░░░░░░░█████████░░░░░░░███
   █████░░░░░░░░░░░░░░░████
        ███████████████
 ]]
      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("f", "⧃ " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", "✚ " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "⏲ " .. " Recent files", ":Telescope oldfiles <CR>"),
        -- dashboard.button("r", "⎋ " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", "䷀ " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "⛭ " .. " Config", ":e $MYVIMRC <CR>"),
        dashboard.button("s", "↻ " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("q", "➲ " .. " Quit", ":qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "Loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },
}
