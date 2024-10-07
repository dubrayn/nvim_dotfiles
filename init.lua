-- #############################################################################

-- Example for configuring Neovim to load user-installed installed Lua rocks:
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local NS = { noremap = true, silent = true }
local win_config = function()
  local height = math.floor(0.618 * vim.o.lines)
  local width = math.floor(0.618 * vim.o.columns)
  return {
    anchor = 'NW', height = height, width = width,
    row = math.floor(0.5 * (vim.o.lines - height)),
    col = math.floor(0.5 * (vim.o.columns - width)),
    border = 'none',
  }
end

-- #############################################################################

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.termguicolors = true

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ","

-- #############################################################################
-- #############################################################################
-- #############################################################################

require("lazy").setup({

  -- ###########################################################################

  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()

      -- #######################################################################

      local function myFilename()
        if vim.fn.expand('%:~:.') == '' or vim.bo.buftype ~= '' then
          return ': %t'
        end
        return '/ ' .. vim.fn.expand('%:~:.')
      end

      require('mini.git').setup({
      })

      require('mini.statusline').setup({
        content = {
          active =
          function()
            MiniStatusline = require('mini.statusline')
            local mode, mode_hl = MiniStatusline.section_mode(       { trunc_width = 120 })
            local git           = MiniStatusline.section_git(        { trunc_width = 40  })
            local diff          = MiniStatusline.section_diff(       { trunc_width = 75  })
            local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75  })
            local lsp           = MiniStatusline.section_lsp(        { trunc_width = 75  })
            local filename      = MiniStatusline.section_filename(   { trunc_width = 140 })
            local fileinfo      = MiniStatusline.section_fileinfo(   { trunc_width = 120 })
            local location      = MiniStatusline.section_location(   { trunc_width = 75  })
            local search        = MiniStatusline.section_searchcount({ trunc_width = 75  })

            return MiniStatusline.combine_groups({
              -- { hl = mode_hl,                  strings = { mode } },
              { hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics, lsp } },
              '%<', -- Mark general truncate point
              { hl = mode_hl, strings = { vim.fn.getcwd() .. myFilename() } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl,                  strings = { search, location } },
            })
          end,
          inactive =
          function()
            MiniStatusline = require('mini.statusline')
            local mode, mode_hl = MiniStatusline.section_mode(       { trunc_width = 120 })
            local git           = MiniStatusline.section_git(        { trunc_width = 40  })
            local diff          = MiniStatusline.section_diff(       { trunc_width = 75  })
            local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75  })
            local lsp           = MiniStatusline.section_lsp(        { trunc_width = 75  })
            local filename      = MiniStatusline.section_filename(   { trunc_width = 140 })
            local fileinfo      = MiniStatusline.section_fileinfo(   { trunc_width = 120 })
            local location      = MiniStatusline.section_location(   { trunc_width = 75  })
            local search        = MiniStatusline.section_searchcount({ trunc_width = 75  })

            return MiniStatusline.combine_groups({
              -- { strings = { mode, } },
              { hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics, lsp } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { vim.fn.getcwd() .. myFilename() } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { strings = { search, location } },
            })
          end,
        },
        use_icons = true,
        set_vim_settings = true
      })
      local animate = require('mini.animate')
      animate.setup {
        scroll = {
          -- Disable Scroll Animations, as the can interfer with mouse Scrolling
          enable = false,
        },
        cursor = {
          timing = animate.gen_timing.cubic({ duration = 50, unit = 'total' })
        },
      }

      -- #######################################################################

      require('mini.basics').setup({
        options = {
          extra_ui    = true,
          win_borders = 'double',
        },
        mappings = {
          windows = true,
        }
      })

      -- #######################################################################

      require('mini.comment').setup({
        mappings = {
          comment        = '<C-c>',
          comment_line   = '<C-c>',
          comment_visual = '<C-c>',
          textobject     = '<C-c>',
        },
      })

      -- #######################################################################

      require('mini.trailspace').setup()

      -- #######################################################################

      require('mini.move').setup({
        mappings = {
          left       = '<C-h>',
          right      = '<C-l>',
          down       = '<C-j>',
          up         = '<C-k>',
          line_left  = '<C-h>',
          line_right = '<C-l>',
          line_down  = '<C-j>',
          line_up    = '<C-k>',
        },
      })

      -- #######################################################################

      require('mini.indentscope').setup({
        draw = {
          animation = function(_, _) return 5 end,
        },
        symbol = "│"
      })

      -- #######################################################################

      require('mini.pick').setup({ -- file picker
        options = {
          use_cache = true
        },
        window = {
          config = win_config,
        }
      })

      -- #######################################################################

    end
  },

  -- ###########################################################################

  {
    "godlygeek/tabular", -- align stuff (:Tabularize \|)
  },

  -- ###########################################################################

  {
    'Vonr/align.nvim',
    branch = "v2",
    lazy = true,
    init = function()
      -- vim.keymap.set( 'x', 'aa', function() require'align'.align_to_char({ length = 1, }) end, NS)
      vim.keymap.set( 'x', 'aa', function() require'align'.align_to_string({ preview = true, regex = false, }) end, NS)
    end
  },

  -- ###########################################################################

  {
    "MunifTanjim/nui.nvim"
  },

  -- ###########################################################################

  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        timeout = 2000,
      })
    end,
  },

  -- ###########################################################################

  {
    'stevearc/aerial.nvim',
    opts = {},
  },

  -- ###########################################################################

  {
    "yssl/TWcmd.vim",
    version = false,
  },

  -- ###########################################################################

  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require('nvim-web-devicons').setup()
    end
  },

  -- ###########################################################################

  {
    "samjwill/nvim-unception"
  },

  -- ###########################################################################

  {
    'williamboman/mason.nvim',
    init = function()
      require('mason').setup()
    end
  },

  -- ###########################################################################

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {'williamboman/mason.nvim'},
    init = function()
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = {"clangd", "lua_ls", "pylsp", "fortls"},
        automatic_installation = true,
      })
    end
  },

  -- ###########################################################################

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {'williamboman/mason.nvim',
    'nvim-neotest/nvim-nio',},
    init = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "cppdbg" },
        automatic_installation = true,
        handlers = {
          function(config)
            require('mason-nvim-dap').default_setup(config)
          end,
          cppdbg = function(config)
            config.configurations = {
              {
                name = 'launch with CLI args',
                type = 'cppdbg',
                request = 'launch',
                program = function() -- Ask the user which executable to debug
                  return vim.fn.input('Path to executable: ',
                  vim.fn.getcwd() .. '/bin/',
                  'file')
                end,
                args = function() -- Ask the user for CLI arguments
                  return {vim.fn.input('CLI arguments (optional): ', '', 'file')}
                end,
                cwd = '${workspaceFolder}',
                runInTerminal = false,
                stopOnEntry = true,
              },
            }

            require('mason-nvim-dap').default_setup(config)
          end,

        },
      })
    end,
  },

  -- ###########################################################################

  {
    'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'
  },

  -- ###########################################################################

  {
    '2kabhishek/nerdy.nvim',
    dependencies = {
      'stevearc/dressing.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = 'Nerdy',
  },

  -- ###########################################################################

  {
    'neovim/nvim-lspconfig',
    dependencies = {'williamboman/mason-lspconfig.nvim'},
    init = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      require("lspconfig").clangd.setup({
        on_init = function(_)
          -- vim.opt.commentstring = '//%s'
          capabilities = capabilities
        end
      })
      require("lspconfig").fortls.setup({})
      require("lspconfig").pylsp.setup({})
      require("lspconfig").lua_ls.setup {
        settings = {
        Lua = {
        -- ^^^^^^^ Missed!
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
          },
        },
      }
    end,
  },

  -- ###########################################################################

  {
    'mfussenegger/nvim-dap',
    enabled = vim.fn.has "win32" == 0,
    event = "User BaseFile",
    dependencies = {
        "jay-babu/mason-nvim-dap.nvim",
        "hrsh7th/nvim-cmp",
        "rcarriga/cmp-dap",
    },
  },

  -- ###########################################################################

  { "hrsh7th/cmp-nvim-lsp" },

  -- ###########################################################################

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      -- "saadparwaiz1/cmp_luasnip",
      -- "L3MON4D3/LuaSnip",
    },

    config = function()
      local cmp = require("cmp")
      vim.opt.completeopt = { "menu", "menuone", "noselect" }

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if #cmp.get_entries() == 1 then
                cmp.confirm({ select = true })
              else
                cmp.select_next_item()
              end
            elseif has_words_before() then
              cmp.complete()
              if #cmp.get_entries() == 1 then
                cmp.confirm({ select = true })
              end
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          -- { name = "otter" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          -- { name = "luasnip" }, -- For luasnip users.
          -- { name = "orgmode" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

    end,
  },

  -- ###########################################################################

  {
    "rcarriga/cmp-dap",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("cmp").setup.filetype(
      { "dap-repl", "dapui_watches", "dapui_hover" },
      {
        sources = {
          { name = "dap" },
        },
      }
      )
    end,
  },

  -- ###########################################################################

  {
    'rcarriga/nvim-dap-ui', -- debug UI
    opts = {
      floating = { border = "rounded", },
      mappings = { open = "<CR>",
                   expand = " ", },
    },
    config = function(_, opts)
      local dap, dapui = require "dap", require "dapui"

      local sign = vim.fn.sign_define

      sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = ""})
      sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = ""})
      sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = ""})
      sign('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })


      dap.listeners.after.event_initialized["dapui_config"] = function(
        )
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function(
        )
        -- dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        -- dapui.close()
      end
      dapui.setup(opts)
    end,
  },

  -- ###########################################################################

  -- {
  --   "lervag/wiki.vim", -- wiki manager [Tab]
  --   init = function()
  --     vim.g.wiki_root = '~/wiki'
  --   end
  -- },

  -- ###########################################################################

  -- {
  --   "vimwiki/vimwiki"
  -- },

  -- ###########################################################################

  {
    "iamcco/markdown-preview.nvim", -- live preview markdown in browser
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 0
    end,
    ft = { "markdown" },
  },

  -- ###########################################################################

  {
    "preservim/vim-markdown", -- conceal markdown links
  },

  -- ###########################################################################

  {
    "tadmccorkle/markdown.nvim", -- follow links (C-Enter)
    ft = "markdown",
    opts = {
      mappings = { link_follow = "<C-Enter>" },
    },
  },

  -- ###########################################################################

  {
    'MeanderingProgrammer/render-markdown.nvim', -- another markdown beautifier
    main = "render-markdown",
    opts = {
      render_modes = { 'n', 'v', 'i', 'c', 't', 'x' },
      anti_conceal = {
        enabled = true,
      },
      checkbox = {
        enabled = false,
      },
      win_options = {
        conceallevel = {
          default = 2,
          rendered = 2,
        },
      },
      bullet = {
        enabled = true,
        -- Replaces '-'|'+'|'*' of 'list_item'
        -- How deeply nested the list is determines the 'level'
        -- The 'level' is used to index into the array using a cycle
        -- If the item is a 'checkbox' a conceal is used to hide the bullet instead
        icons = { '●', '○', '◆', '◇' },
        -- Padding to add to the left of bullet point
        left_pad = 1,
        -- Padding to add to the right of bullet point
        right_pad = 0,
        -- Highlight for the bullet icon
        highlight = 'RenderMarkdownBullet',
      },
      link = {
        enabled = false,
      },
      heading = {
        -- Turn on / off heading icon & background rendering
        enabled = true,
        -- Turn on / off any sign column related rendering
        sign = false,
        -- Replaces '#+' of 'atx_h._marker'
        -- The number of '#' in the heading determines the 'level'
        -- The 'level' is used to index into the array using a cycle
        -- The result is left padded with spaces to hide any additional '#'
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        -- Added to the sign column if enabled
        -- The 'level' is used to index into the array using a cycle
        signs = { '󰫎 ' },
        -- Width of the heading background:
        --  block: width of the heading text
        --  full: full width of the window
        width = 'block',
        left_pad = 0,
        right_pad = 1,
        backgrounds = {
          'RenderMarkdownH1Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH3Bg',
          'RenderMarkdownH4Bg',
          'RenderMarkdownH5Bg',
          'RenderMarkdownH6Bg',
        },
        foregrounds = {
          'RenderMarkdownH1',
          'RenderMarkdownH2',
          'RenderMarkdownH3',
          'RenderMarkdownH4',
          'RenderMarkdownH5',
          'RenderMarkdownH6',
        },
      },

      code = {
        -- Turn on / off code block & inline code rendering
        enabled = true,
        -- Turn on / off any sign column related rendering
        sign = false,
        -- Determines how code blocks & inline code are rendered:
        --  none: disables all rendering
        --  normal: adds highlight group to code blocks & inline code, adds padding to code blocks
        --  language: adds language icon to sign column if enabled and icon + name above code blocks
        --  full: normal + language
        style = 'full',
        -- Amount of padding to add to the left of code blocks
        left_pad = 1,
        -- Amount of padding to add to the right of code blocks when width is 'block'
        right_pad = 1,
        -- Width of the code block background:
        --  block: width of the code block
        --  full: full width of the window
        width = 'block',
        -- Determins how the top / bottom of code block are rendered:
        --  thick: use the same highlight as the code body
        --  thin: when lines are empty overlay the above & below icons
        border = 'thin',
        -- Used above code blocks for thin border
        -- above = '▄',
        above = '-',
        -- Used below code blocks for thin border
        -- below = '▀',
        below = '-',
        -- Highlight for code blocks & inline code
        highlight = 'RenderMarkdownCode',
        highlight_inline = 'RenderMarkdownCodeInline',
      },
      callout = {
        note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
        tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
        important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
        warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
        caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
        -- Obsidian: https://help.a.md/Editing+and+formatting/Callouts
        abstract = { raw = '[!ABSTRACT]', rendered = '󰨸 Abstract', highlight = 'RenderMarkdownInfo' },
        todo = { raw = '[!TODO]', rendered = '󰗡 Todo', highlight = 'RenderMarkdownInfo' },
        success = { raw = '[!SUCCESS]', rendered = '󰄬 Success', highlight = 'RenderMarkdownSuccess' },
        question = { raw = '[!QUESTION]', rendered = '󰘥 Question', highlight = 'RenderMarkdownWarn' },
        failure = { raw = '[!FAILURE]', rendered = '󰅖 Failure', highlight = 'RenderMarkdownError' },
        danger = { raw = '[!DANGER]', rendered = '󱐌 Danger', highlight = 'RenderMarkdownError' },
        bug = { raw = '[!BUG]', rendered = '󰨰 Bug', highlight = 'RenderMarkdownError' },
        example = { raw = '[!EXAMPLE]', rendered = '󰉹 Example', highlight = 'RenderMarkdownHint' },
        quote = { raw = '[!QUOTE]', rendered = '󱆨 Quote', highlight = 'RenderMarkdownQuote' },
      },
      latex = { enabled = false },
    },

    name = 'render-markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
  },

  -- ###########################################################################

  -- {
  --   'simonmclean/triptych.nvim', -- 3-panels file manager
  --   event = 'VeryLazy',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --   },
  --   init = function()
  --     require('triptych').setup()
  --   end
  -- },

  -- ###########################################################################

  {
    "catppuccin/nvim", -- color theme
    name = "catppuccin",
    priority = 1000,
    init = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 1.80,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = true,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
        },
      })
    end,
  },

  -- ###########################################################################

  {
    "dubrayn/molten-nvim", -- fork of "benlubas/molten-nvim" - REPL
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_auto_init_behavior = "init"
      vim.g.molten_enter_output_behavior = "open_and_enter"
      vim.g.molten_auto_image_popup = false
      vim.g.molten_auto_open_output = false
      vim.g.molten_output_crop_border = false
      vim.g.molten_output_virt_lines = true
      vim.g.molten_output_win_max_height = 50
      vim.g.molten_output_win_style = "minimal"
      vim.g.molten_output_win_hide_on_leave = false
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_virt_text_max_lines = 10000
      vim.g.molten_cover_empty_lines = false
      vim.g.molten_copy_output = true
      vim.g.molten_output_show_exec_time = false
    end,
  },

  -- ###########################################################################

  -- {
  --   'quarto-dev/quarto-nvim',
  --   opts = {
  --     debug = false,
  --     closePreviewOnExit = true,
  --     lspFeatures = {
  --       enabled = true,
  --       chunks = "curly",
  --       languages = { "python", },
  --       diagnostics = {
  --         enabled = true,
  --         triggers = { "BufWritePost" },
  --       },
  --       completion = {
  --         enabled = true,
  --       },
  --     },
  --     codeRunner = {
  --       enabled = true,
  --       default_method = 'molten', -- 'molten' or 'slime'
  --       ft_runners = { python = 'molten' }, -- filetype to runner, ie. `{ python = "molten" }`.
  --       -- Takes precedence over `default_method`
  --       never_run = { "yaml" }, -- filetypes which are never sent to a code runner
  --     },
  --   },
  -- },
  --
  -- {
  --   'jmbuhr/otter.nvim',
  --   'hrsh7th/nvim-cmp',
  --   'neovim/nvim-lspconfig',
  --   'nvim-treesitter/nvim-treesitter'
  -- },

  -- ###########################################################################

  {
    "chrisgrieser/nvim-various-textobjs", -- additional text objects
    lazy = false,
    opts = { useDefaultKeymaps = true },
  },

  -- ###########################################################################

  {
    "3rd/image.nvim", -- display images in kitty terminal
    dependencies = {
      "vhyrro/luarocks.nvim",
      priority = 1001,
      opts = {
        rocks = { "magick" },
      },
    },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true
        },
      },
      max_width = 500,
      max_height = 500,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "noice", "" },
    },

  },

  -- ###########################################################################

  -- {
  --   "gennaro-tedesco/nvim-possession", -- session manager
  --   dependencies = {
  --     "ibhagwan/fzf-lua",
  --   },
  --   config = true,
  --   init = function()
  --     local possession = require("nvim-possession")
  --     vim.keymap.set("n", "<leader>sl", function()
  --       possession.list()
  --     end)
  --     vim.keymap.set("n", "<leader>sn", function()
  --       possession.new()
  --     end)
  --     vim.keymap.set("n", "<leader>su", function()
  --       possession.update()
  --     end)
  --     vim.keymap.set("n", "<leader>sd", function()
  --       possession.delete()
  --     end)
  --   end,
  -- },

  -- ###########################################################################

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "markdown", "markdown_inline" },
        highlight = { enable = true },
      })
    end,
  },

  -- -- ###########################################################################

  -- {
  --   "nvim-treesitter/playground",
  --
  --   config = function()
  --     require "nvim-treesitter.configs".setup {
  --       playground = {
  --         enable = true,
  --         disable = {},
  --         updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
  --         persist_queries = false, -- Whether the query persists across vim sessions
  --         keybindings = {
  --           toggle_query_editor = 'o',
  --           toggle_hl_groups = 'i',
  --           toggle_injected_languages = 't',
  --           toggle_anonymous_nodes = 'a',
  --           toggle_language_display = 'I',
  --           focus_language = 'f',
  --           unfocus_language = 'F',
  --           update = 'R',
  --           goto_node = '<cr>',
  --           show_help = '?',
  --         },
  --       }
  --     }
  --   end,
  -- },

  -- ###########################################################################

  {
    "NStefan002/screenkey.nvim", -- show keys pressed (:Screenkey)
    cmd = "Screenkey",
    config = true,
  },

  -- ###########################################################################

  {
    "airblade/vim-rooter", -- autochdir to git project
    init = function()
      vim.g.rooter_patterns = {'.git', '.stfolder'}
      -- vim.g.rooter_patterns = {'.git'}
     vim.g.rooter_change_directory_for_non_project_files = 'current'
     vim.g.rooter_silent_chdir = 1
    end,
  },

  -- ###########################################################################

  {
    "azabiong/vim-highlighter", -- highlight selections
    init = function()
    end,
  },

  -- ###########################################################################

  {
    'stevearc/oil.nvim', -- file manager (C-f)
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
  },

  -- ###########################################################################

  {
    "uga-rosa/ccc.nvim", -- color picker (:CccPick)
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true,
      },
    },
  },

  -- ###########################################################################

  {
    "dosimple/workspace.vim", -- treat tabs as virtual workspaces
    init = function()
    end,
  },

  -- ###########################################################################
})

-- #############################################################################
-- #############################################################################
-- #############################################################################

local is_something_shown = function()
  if vim.fn.argc() > 0 then return true end
  local listed_buffers = vim.tbl_filter(
    function(buf_id) return vim.fn.buflisted(buf_id) == 1 end,
    vim.api.nvim_list_bufs()
  )
  if #listed_buffers > 1 then return true end
  local n_lines = vim.api.nvim_buf_line_count(0)
  if n_lines > 1 then return true end
  local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, true)[1]
  if string.len(first_line) > 0 then return true end

  return false
end

local augroup = vim.api.nvim_create_augroup('StarterPage', {})

local on_vimenter = function()
  if is_something_shown() then return end
  vim.cmd('e ~/wiki/main.md')
end

vim.api.nvim_create_autocmd( "VimEnter" , { group = augroup, nested = true, once = true, callback = on_vimenter, desc = 'Open on VimEnter' })
vim.api.nvim_create_autocmd("BufEnter"  , { pattern = "term://*", callback = function() vim.cmd('startinsert'); vim.opt_local.number = false; end })
vim.api.nvim_create_autocmd("TermEnter" , { callback = function() vim.opt_local.number = false; end })
vim.api.nvim_create_autocmd("BufEnter"  , { callback = function() vim.opt_local.formatoptions = "jnql"; end })

-- #############################################################################
-- #############################################################################
-- #############################################################################

vim.keymap.set({"n"          }, ";"          , ":"                                         , NS)
vim.keymap.set({"n"          }, "<Return>"   , "ciw"                                       , NS)
vim.keymap.set({          "t"}, "<M-Esc>"    , "<C-\\><C-n>"                               , NS)
vim.keymap.set({"n", "i", "t"}, "<C-q>"      , "<cmd>qa!<cr>"                              , NS)
vim.keymap.set({"n", "i", "t"}, "<M-c>"      , "<cmd>q!<cr>"                               , NS)
vim.keymap.set({"n", "i", "t"}, "<M-h>"      , "<cmd>TWcmd wcm h<cr>"                      , NS)
vim.keymap.set({"n", "i", "t"}, "<M-j>"      , "<cmd>TWcmd wcm j<cr>"                      , NS)
vim.keymap.set({"n", "i", "t"}, "<M-k>"      , "<cmd>TWcmd wcm k<cr>"                      , NS)
vim.keymap.set({"n", "i", "t"}, "<M-l>"      , "<cmd>TWcmd wcm l<cr>"                      , NS)
vim.keymap.set({"n", "i", "t"}, "<M-C-h>"    , "<cmd>TWcmd wmv h<cr>"                      , NS)
vim.keymap.set({"n", "i", "t"}, "<M-C-j>"    , "<cmd>TWcmd wmv j<cr>"                      , NS)
vim.keymap.set({"n", "i", "t"}, "<M-C-k>"    , "<cmd>TWcmd wmv k<cr>"                      , NS)
vim.keymap.set({"n", "i", "t"}, "<M-C-l>"    , "<cmd>TWcmd wmv l<cr>"                      , NS)
vim.keymap.set({"n", "i", "t"}, "<M-S-j>"    , "<cmd>horizontal resize -1<cr>"             , NS)
vim.keymap.set({"n", "i", "t"}, "<M-S-h>"    , "<cmd>vertical resize -1<cr>"               , NS)
vim.keymap.set({"n", "i", "t"}, "<M-S-l>"    , "<cmd>vertical resize +1<cr>"               , NS)
vim.keymap.set({"n", "i", "t"}, "<M-S-k>"    , "<cmd>horizontal resize +1<cr>"             , NS)
vim.keymap.set({"n", "i", "t"}, "<M-Left>"   , "<cmd>TWcmd wcm h<cr>"                      , NS)
vim.keymap.set({"n", "i", "t"}, "<M-Down>"   , "<cmd>TWcmd wcm j<cr>"                      , NS)
vim.keymap.set({"n", "i", "t"}, "<M-Up>"     , "<cmd>TWcmd wcm k<cr>"                      , NS)
vim.keymap.set({"n", "i", "t"}, "<M-Right>"  , "<cmd>TWcmd wcm l<cr>"                      , NS)
vim.keymap.set({"n", "i", "t"}, "<M-C-Left>" , "<cmd>TWcmd wmv h<cr>"                      , NS)
vim.keymap.set({"n", "i", "t"}, "<M-C-Down>" , "<cmd>TWcmd wmv j<cr>"                      , NS)
vim.keymap.set({"n", "i", "t"}, "<M-C-Up>"   , "<cmd>TWcmd wmv k<cr>"                      , NS)
vim.keymap.set({"n", "i", "t"}, "<M-C-Right>", "<cmd>TWcmd wmv l<cr>"                      , NS)
vim.keymap.set({"n", "i"     }, "<M-Enter>"  , "<cmd>terminal!<cr>"                        , NS)
vim.keymap.set({          "t"}, "<M-Enter>"  , "<cmd>enew!<cr>"                            , NS)
vim.keymap.set({"n", "i", "t"}, "<M-f>"      , "<cmd>lua MiniPick.builtin.files(    )<cr>" , NS)
vim.keymap.set({"n", "i", "t"}, "<M-g>"      , "<cmd>lua MiniPick.builtin.grep_live()<cr>" , NS)
vim.keymap.set({"n",      "t"}, "<M-v>"      , "<cmd>new<cr><cmd>terminal<cr>"             , NS)
vim.keymap.set({     "i",    }, "<M-v>"      , "<Esc><cmd>new<cr><cmd>terminal<cr>"        , NS)
vim.keymap.set({"n",         }, "<M-b>"      , ":vnew<cr>:terminal<cr>"                    , NS)
vim.keymap.set({          "t"}, "<M-b>"      , "<C-\\><C-n>:vnew<cr>:terminal<cr>"         , NS)
vim.keymap.set({     "i",    }, "<M-b>"      , "<Esc><cmd>vnew<cr><cmd>terminal<cr>"       , NS)
vim.keymap.set({"n", "i"     }, "<C-l>"      , "<cmd>nohl<cr>"                             , NS)
vim.keymap.set({"n", "i", "t"}, "<M-Space>"  , "<cmd>e! ~/wiki/main.md<cr>"                , NS)
vim.keymap.set({"n", "i"     }, "<C-s>"      , "<cmd>ClangdSwitchSourceHeader<cr>"         , NS)
vim.keymap.set({"n", "i"     }, "<leader>db" , "<cmd>DapToggleBreakpoint<cr>"              , NS)
vim.keymap.set({"n", "i"     }, "<leader>dc" , "<cmd>DapContinue<cr>"                      , NS)
vim.keymap.set({"v"          }, "gt"         , ":!column -t -s '|' -o '|'<cr>"             , NS)
vim.keymap.set({"n"          }, "{"          , "<cmd>AerialPrev<cr>"                       , NS)
vim.keymap.set({"n"          }, "}"          , "<cmd>AerialNext<cr>"                       , NS)
vim.keymap.set({"n", "i", "t"}, "<C-f>"      , "<cmd>Oil<cr>"                              , NS)
vim.keymap.set({"n", "i", "t"}, "<M-p>"      , "ProjectMgr"                                , NS)
vim.keymap.set({"x"          }, "<S-Enter>"  , ":<C-u>MoltenEvaluateVisual<cr>gv"          , NS)
vim.keymap.set({"n"          }, "<C-S-h>"    , "<cmd>MoltenHideOutput<cr>"                 , NS)
vim.keymap.set({"n"          }, "<C-S-s>"    , "<cmd>noautocmd MoltenEnterOutput<cr>"      , NS)
vim.keymap.set({"n"          }, "<C-S-r>"    , "<cmd>MoltenReevaluateAll<cr>"              , NS)
vim.keymap.set({"n"          }, "<C-S-j>"    , "<cmd>MoltenNext<cr>"                       , NS)
vim.keymap.set({"n"          }, "<C-S-k>"    , "<cmd>MoltenPrev<cr>"                       , NS)
vim.keymap.set({"n"          }, "<Tab>"      , "/\\(```.\\|](\\)<cr>:nohl<cr>"             , NS)
vim.keymap.set({"n"          }, "<S-Tab>"    , "?\\(```.\\|](\\)<cr>:nohl<cr>"             , NS)
vim.keymap.set({"n",         }, "K"          , function() require("dapui").eval() end      , NS)
vim.keymap.set({"n", "i"     }, "<C-n>"      , function() vim.diagnostic.goto_next() end   , NS)
vim.keymap.set({"n", "i"     }, "<C-p>"      , function() vim.diagnostic.goto_prev() end   , NS)
vim.keymap.set({"n", "i"     }, "<C-d>"      , function() vim.lsp.buf.declaration() end    , NS)
vim.keymap.set({"n", "i"     }, "<C-t>"      , function() vim.lsp.buf.type_definition() end, NS)

vim.keymap.set({"n", "i", "t"}, "<M-p>"      , function() vim.cmd("WS 10<cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-q>"      , function() vim.cmd("WS 1 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-w>"      , function() vim.cmd("WS 2 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-e>"      , function() vim.cmd("WS 3 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-r>"      , function() vim.cmd("WS 4 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-t>"      , function() vim.cmd("WS 5 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-y>"      , function() vim.cmd("WS 6 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-u>"      , function() vim.cmd("WS 7 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-i>"      , function() vim.cmd("WS 8 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-o>"      , function() vim.cmd("WS 9 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-p>"      , function() vim.cmd("WS 10<cr>"); on_vimenter(); end, NS)

vim.keymap.set({"n", "i", "t"}, "<M-S-q>"    , function() vim.cmd("WSbmv 1 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-S-w>"    , function() vim.cmd("WSbmv 2 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-S-e>"    , function() vim.cmd("WSbmv 3 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-S-r>"    , function() vim.cmd("WSbmv 4 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-S-t>"    , function() vim.cmd("WSbmv 5 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-S-y>"    , function() vim.cmd("WSbmv 6 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-S-u>"    , function() vim.cmd("WSbmv 7 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-S-i>"    , function() vim.cmd("WSbmv 8 <cr>"); on_vimenter(); end, NS)
vim.keymap.set({"n", "i", "t"}, "<M-S-o>"    , function() vim.cmd("WSbmv 9 <cr>"); on_vimenter(); end, NS)

vim.keymap.set({"n"          }, "<S-Enter>"  , function() require("various-textobjs").mdFencedCodeBlock("inner"); vim.cmd("MoltenEvaluateOperator"); end, NS)
vim.keymap.set({     "i"     }, "<S-Enter>"  , function() vim.cmd("stopinsert"); require("various-textobjs").mdFencedCodeBlock("inner"); vim.cmd("MoltenEvaluateOperator"); end, NS)

-- #############################################################################
-- #############################################################################
-- #############################################################################

-- Cosmetic stuff
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "None" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3b3754" })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeOther', { link = 'IncSearch' })

-- #############################################################################
-- #############################################################################
-- #############################################################################

-- Global options
vim.opt.listchars = { extends='.',precedes='|',nbsp='_', tab='└─┘' }
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.relativenumber = false
vim.opt.number = false
vim.opt.scl = "auto"
vim.opt.scrolloff = 10
vim.opt.laststatus = 2
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"
vim.opt.autochdir = false
vim.opt.signcolumn = "number"
vim.opt.showtabline = 0
vim.opt.hidden = true

-- #############################################################################
-- #############################################################################
-- #############################################################################

-- no auto comment on new line
vim.opt.formatoptions = "jnql"

vim.opt.fillchars = {
  horiz     = '─',
  horizup   = '┴',
  horizdown = '┬',
  vert      = '│',
  vertleft  = '┤',
  vertright = '├',
  verthoriz = '┼',
}

-- #############################################################################
-- #############################################################################
-- #############################################################################

-- color tweaks
vim.cmd.colorscheme "catppuccin"
vim.cmd('highlight CursorLine guibg=#162859 guifg=NONE')
vim.cmd('highlight MatchParen guibg=#FF8080 guifg=black')
vim.cmd('highlight Comment guifg=#aa77ff')
vim.cmd('highlight Visual guibg=#990000')
vim.cmd('highlight Search guibg=#00FF00 guifg=#000000')
vim.cmd('highlight DiffText guibg=#AA0000')
vim.cmd('highlight! link CurSearch Search')
vim.cmd('highlight DapStopped guibg=#660000')

vim.cmd('highlight RenderMarkdownH1Bg guifg=#00ffff guibg=#444444')
vim.cmd('highlight RenderMarkdownH2Bg guifg=#00ff00 guibg=#444444')
vim.cmd('highlight RenderMarkdownH3Bg guifg=#ffff00 guibg=#444444')
vim.cmd('highlight RenderMarkdownCode guibg=#373750')
vim.cmd('highlight RenderMarkdownCodeInline guifg=#ffffff')

-- #############################################################################
-- #############################################################################
-- #############################################################################

vim.opt.maxmempattern=2000000
vim.opt.sessionoptions="blank,buffers,curdir,folds,help,resize,tabpages,terminal,winsize,options"

-- hide Markdown links
vim.opt.conceallevel=2
vim.opt.foldlevel=2

-- vim.cmd("let g:vim_markdown_new_list_item_indent = 2")
