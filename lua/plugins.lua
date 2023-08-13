-- Bootstrap lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- `cond = false` to disable plugin
local plugins = {
    {
        'folke/tokyonight.nvim', -- Color Scheme
        lazy = false,            -- make sure we load this during startup if it is your main colorscheme
        priority = 1000,         -- make sure to load this before all the other start plugins
        config = function()
            require("tokyonight").setup({
                on_highlights = function(hl, c)
                    hl.DiffText = { bg = c.diff.text, bold = true }
                    hl.DiffChange = { bg = c.diff.text, bold = true }
                end,
                styles = {
                    keywords = { italic = false },
                },
            })
            vim.cmd([[colorscheme tokyonight-moon]])
        end,
    },
    { 'christoomey/vim-tmux-navigator' },
    {
        'ibhagwan/fzf-lua', -- Fuzzy Find
        opts = {
            'default', -- 'fzf-native',
            winopts = {
                preview = {
                    layout = "vertical"
                }
            },
            grep = {
                -- rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096"
            },
            keymap = {
                fzf = {
                    ["ctrl-d"] = "toggle-all",
                    ["ctrl-q"] = "select-all+accept",
                },
            },
        },
        init = function ()
            require('fzf-lua').register_ui_select()
        end
        -- pin = true,
    },
    {
        'nvim-neo-tree/neo-tree.nvim', -- Tree navigation
        branch = 'v3.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
        },
        opts = {
            filesystem = {
                filtered_items = {
                    hide_gitignored = false
                },
                follow_current_file = {
                    enabled = true,
                },
                window = {
                    mappings = {
                        ['g'] = 'grep',
                        ['G'] = 'grepsensitive',
                        ['f'] = 'fzffind',
                        ['o'] = 'system_open',
                    },
                },
                commands = {
                    fzffind = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        require 'fzf-lua'.files({ cwd = path })
                    end,
                    grep = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        require 'fzf-lua'.live_grep({ cwd = path })
                    end,
                    grepsensitive = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        require 'fzf-lua'.live_grep_glob({
                            cwd = path,
                            cmd = 'rg --column --line-number --no-heading --color=always '
                        })
                    end,
                    system_open = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        local cmd = "open " .. path
                        vim.fn.system(cmd)
                    end
                },
            },
            source_selector = {
                winbar = true,
                statusline = false,
                sources = {
                    { source = "filesystem", display_name = " 󰉓 Files " },
                    { source = "buffers", display_name = " 󱉲 Buffers " },
                    { source = "git_status", display_name = " 󰊢 Git " },
                },
            },
            default_component_configs = {
                icon = {
                    folder_empty = "󰜌",
                    folder_empty_open = "󰜌",
                },
                git_status = {
                    symbols = {
                        renamed   = "󰁕",
                        unstaged  = "󰄱",
                    },
                },
            },
            document_symbols = {
                kinds = {
                    File = { icon = "󰈙", hl = "Tag" },
                    Namespace = { icon = "󰌗", hl = "Include" },
                    Package = { icon = "󰏖", hl = "Label" },
                    Class = { icon = "󰌗", hl = "Include" },
                    Property = { icon = "󰆧", hl = "@property" },
                    Enum = { icon = "󰒻", hl = "@number" },
                    Function = { icon = "󰊕", hl = "Function" },
                    String = { icon = "󰀬", hl = "String" },
                    Number = { icon = "󰎠", hl = "Number" },
                    Array = { icon = "󰅪", hl = "Type" },
                    Object = { icon = "󰅩", hl = "Type" },
                    Key = { icon = "󰌋", hl = "" },
                    Struct = { icon = "󰌗", hl = "Type" },
                    Operator = { icon = "󰆕", hl = "Operator" },
                    TypeParameter = { icon = "󰊄", hl = "Type" },
                    StaticMethod = { icon = '󰠄 ', hl = 'Function' },
                }
            },
            -- -- Add this section only if you've configured source selector.
            -- source_selector = {
            --     sources = {
            --         { source = "filesystem", display_name = " 󰉓 Files " },
            --         { source = "git_status", display_name = " 󰊢 Git " },
            --     },
            -- },
        },
    },
    {
        'nvim-lualine/lualine.nvim', -- custom status bar
        lazy = false,
        priority = 1000,
        -- pin = true,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'SmiteshP/nvim-navic',
            'ibhagwan/fzf-lua',
        },
        config = function()
            local navic = require 'nvim-navic'
            require 'lualine'.setup {
                options = {
                    theme = 'tokyonight',
                    icons_enabled = true,
                    path = 1,
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                },
                sections = {
                    lualine_a = { { 'mode', fmt = function(str)
                        local lower_mode = str:lower()
                        local single_char = lower_mode:sub(1, 1)
                        local first_mode = lower_mode:sub(1, 2)
                        if first_mode == "v-" then
                            return lower_mode
                        end
                        return single_char

                    end } },
                    lualine_b = {
                        {
                            'diff',
                            on_click = function(_,_,_)
                                vim.cmd('Gvdiffsplit')
                            end
                        },
                        {
                            'diagnostics',
                            on_click = function(_,_,_)
                                vim.cmd('TroubleToggle document_diagnostics')
                            end

                        }
                    },
                    lualine_c = {
                        {
                            'filename',
                            symbols = {
                                readonly = '',      -- Text to show when the file is non-modifiable or readonly.
                            }
                        }
                    },
                    lualine_x = {
                        {
                            'encoding',
                        },
                        -- {
                        --     function()
                        --         local space_pat = [[\v^ +]]
                        --         local tab_pat = [[\v^\t+]]
                        --         local space_indent = vim.fn.search(space_pat, 'nwc')
                        --         local tab_indent = vim.fn.search(tab_pat, 'nwc')
                        --         local mixed = (space_indent > 0 and tab_indent > 0)
                        --         local mixed_same_line
                        --         if not mixed then
                        --             mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], 'nwc')
                        --             mixed = mixed_same_line > 0
                        --         end
                        --         if not mixed and space_indent > 0 then
                        --             return "󱁐"
                        --         end
                        --         if not mixed and tab_indent > 0 then
                        --             return "󰌒"
                        --         end
                        --         if mixed_same_line ~= nil and mixed_same_line > 0 then
                        --             return ':'..mixed_same_line
                        --         end
                        --         local space_indent_cnt = vim.fn.searchcount({pattern=space_pat, max_count=1e3}).total
                        --         local tab_indent_cnt =  vim.fn.searchcount({pattern=tab_pat, max_count=1e3}).total
                        --         if space_indent_cnt == 0 and tab_indent_cnt == 0 then
                        --             return "󰢤"
                        --         end
                        --         if space_indent_cnt > tab_indent_cnt then
                        --             return ':'..tab_indent
                        --         else
                        --             return ':'..space_indent
                        --         end
                        --     end
                        -- },
                        {
                            'filetype',
                            on_click = function(_,_,_)
                                require('fzf-lua').filetypes()
                            end
                        }
                    },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                tabline = {
                    lualine_a = {
                        {
                            function()
                                local msg = ''
                                local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                                local clients = vim.lsp.get_active_clients()
                                if next(clients) == nil then
                                    return msg
                                end
                                for _, client in ipairs(clients) do
                                    local filetypes = client.config.filetypes
                                    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                                        return " " .. client.name
                                    end
                                end
                                return msg
                            end,
                            on_click = function(_,_,_)
                                vim.cmd('LspInfo')
                            end
                        }
                    },
                    lualine_b = {
                        {
                            'branch',
                            on_click = function(_,_,_)
                                LazygitToggle()
                            end
                        },
                    },
                    lualine_c = {
                        {
                            function() return navic.get_location() end,
                            cond = navic.is_available,
                        },
                    },
                    lualine_z = {
                        {
                            function()
                                local hostname = vim.loop.os_gethostname()
                                if string.find(hostname, 'local') then
                                    return 'λ'
                                else
                                    return 'δ'
                                end
                            end
                        }
                    },
                    lualine_y = {
                        {
                            'tabs',
                            mode = 0,
                        },
                    }
                },
                extensions = {
                    'fzf',
                    'lazy',
                    'toggleterm',
                    'symbols-outline',
                    'trouble',
                    'neo-tree',
                    {
                       filetypes = { 'help' },
                       sections = {
                           lualine_a = { function () return '?' end },
                           lualine_c = {
                               {
                                   'filename',
                                   path = 0,
                                   symbols = {
                                       readonly = '',
                                   }
                               }
                           },
                           lualine_z = { 'location' },
                       }

                    },
                    {
                       filetypes = { 'fugitiveblame' },
                       sections = {
                           lualine_a = { function ()
                               return 'Blame'
                           end },
                           lualine_z = { 'location' },
                       }

                    },
                    {
                        filetypes = { 'qf' },
                        sections = {
                            lualine_a = { function ()
                                if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
                                    return 'Loclist'
                                else
                                    return 'Quickfix'
                                end
                            end },
                            lualine_b = { function ()
                                if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
                                    return vim.fn.getloclist(0, { title = 0 }).title
                                else
                                    return vim.fn.getqflist({ title = 0 }).title
                                end
                            end },
                            lualine_z = { 'location' },
                        }
                    }
                },
            }
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = function()
            require 'nvim-treesitter.install'.update({ with_sync = true })
        end,
        config = function(_, opts)
            vim.opt.foldmethod = 'expr'
            vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
            vim.opt.foldlevel = 25
            require 'nvim-treesitter.configs'.setup {
                -- ensure_installed = {
                --     'bash', 'help', 'html', 'javascript', 'json',
                --     'lua', 'markdown', 'markdown_inline', 'python',
                --     'query', 'regex', 'tsx', 'typescript', 'vim',
                --     'yaml', 'kotlin', 'go', 'latex', 'bibtex',
                --     'c', 'cpp', 'css', 'diff', 'elm',
                --     'git_rebase', 'gitattributes', 'gitcommit',
                --     'graphql', 'gomod', 'make',
                --     'terraform',
                -- },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<c-space>',
                        node_incremental = '<c-space>',
                        scope_incremental = '<c-s>',
                        node_decremental = '<M-space>',
                    },
                },
                indent = {
                    enable = true
                },
                textobjects = {
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            [']m'] = '@function.outer',
                        },
                        goto_next_end = {
                            [']M'] = '@function.outer',
                        },
                        goto_previous_start = {
                            ['[m'] = '@function.outer',
                        },
                        goto_previous_end = {
                            ['[M'] = '@function.outer',
                        },
                    },
                },
            }
        end,
    },
    { 
        'Raimondi/delimitMate',
        config = function()
            local g = vim.g
            g.delimitMate_expand_cr = 1
            g.delimitMate_expand_space = 1
        end
    },
    {
        'folke/which-key.nvim',
        dependencies = { 'afreakk/unimpaired-which-key.nvim' },
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 400
            local wk = require 'which-key'
            wk.setup {
                plugins = {
                    spelling = {
                        enabled = true,
                        suggestions = 30,
                    },
                },
                window = {
                    border = 'rounded', -- none, single, double, shadow
                },
            }
            local Terminal = require('toggleterm.terminal').Terminal
            local lazygit  = Terminal:new({
                cmd = "lazygit",
                hidden = true,
                float_opts = {
                    border = "double",
                },
                on_open = function(term)
                    vim.cmd("startinsert!")
                    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
                end,
                -- function to run on closing the terminal
                on_close = function(_)
                    vim.cmd("startinsert!")
                end,
            })
            function LazygitToggle()
                lazygit:toggle()
            end

            -- Import locally defined keymappings
            local keymaps = require'keymap'

            -- term bindings
            wk.register(keymaps.term, { mode = 't' })

            -- visual bindings
            wk.register(keymaps.visual, { mode = 'v' })

            -- normal bindings
            wk.register(keymaps.normal)

            -- Register unimpaired key bindings
            local uwk = require'unimpaired-which-key'
            wk.register(uwk.normal_mode)
            wk.register(uwk.normal_and_visual_mode, { mode = { 'n', 'v' } })
        end,
    },
    { 'tpope/vim-commentary' },
    { 'tpope/vim-unimpaired' },
    { 'tpope/vim-surround' },
    {
        'kevinhwang91/nvim-bqf', -- better quick fix
        opts = {
            preview = {
                winblend = 0
            }
        }
    },
    { 'ashfinal/qfview.nvim', config = true, pin = true }, -- quick fix formatting
    {
        'j-hui/fidget.nvim', -- display lsp loading info
        config = true ,
        tag = 'legacy',
    },
    {
        'folke/trouble.nvim', -- makes errors look nicer
        opts = {
            mode = 'document_diagnostics',
        },
    },
    {
        'simrat39/symbols-outline.nvim',
        opts = {
            symbols = {
                Array = { icon = "󰅪", hl = "Type" },
                Boolean = { icon = '⊨', hl = '@boolean' },
                Class = { icon = "󰌗", hl = "Include" },
                Component = { icon = '󰌗', hl = '@function' },
                Constant = { icon = '', hl = '@constant' },
                Constructor = { icon = '', hl = '@constructor' },
                Enum = { icon = "󰒻", hl = "@number" },
                EnumMember = { icon = '', hl = '@field' },
                Event = { icon = '', hl = '@type' },
                Field = { icon = '󰇽', hl = '@field' },
                File = { icon = "󰈙", hl = "Tag" },
                Fragment = { icon = '󰈙', hl = '@constant' },
                Function = { icon = "󰊕", hl = "Function" },
                Interface = { icon = '', hl = '@type' },
                Key = { icon = "󰌋", hl = "" },
                Method = { icon = 'ƒ', hl = '@method' },
                Module = { icon = '', hl = '@namespace' },
                Namespace = { icon = "󰌗", hl = "Include" },
                Null = { icon = 'NULL', hl = '@type' },
                Number = { icon = "󰎠", hl = "Number" },
                Object = { icon = "󰅩", hl = "Type" },
                Operator = { icon = "󰆕", hl = "Operator" },
                Package = { icon = "󰏖", hl = "Label" },
                Property = { icon = "󰆧", hl = "@property" },
                String = { icon = "󰀬", hl = "String" },
                Struct = { icon = "󰌗", hl = "Type" },
                TypeParameter = { icon = "󰊄", hl = "Type" },
                Variable = { icon = '', hl = '@constant' },
            },
        },
    },
    {
        'akinsho/toggleterm.nvim', -- Adds a floating term window
        opts = {
            direction = 'float',
            winbar = {
                enabled = true,
                name_formatter = function(term)
                    return term.name
                end
            },
            persist_mode = false,
        },
    },
    {
        'chentoast/marks.nvim', -- adds gutter symbols for marks.
        opts = {
            default_mappings = false,
            builtin_marks = { },
            refresh_interval = 500,
            excluded_filetypes = { 'toggleterm', 'fugitive', 'fugitiveblame', 'quickfix', 'neo-tree' },
        },
    },
    {
        'airblade/vim-gitgutter',
        init = function()
            -- vim.g.signcolumn = 'auto'
            vim.g.gitgutter_map_keys = 1
            vim.g.gitgutter_highlight_linenrs = 1
        end,
        config = function ()
            local opts = vim.g.gitgutter_floating_window_options
            opts.border = 'rounded'
            vim.g.gitgutter_floating_window_options = opts
            -- vim.g.gitgutter_highlight_linenrs = 1
            -- vim.g.gitgutter_highlight_linenrs = true
        end,
    },
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-rhubarb' },
    -- {
    --     'lukas-reineke/indent-blankline.nvim', -- Add colors to indent columns
    --     config = function()
    --         vim.cmd [[highlight IndentBlanklineContextStart guisp=#82aaff gui=underline]]
    --         vim.cmd [[highlight IndentBlanklineContextChar guifg=#82aaff gui=nocombine]]
    --         vim.cmd [[highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine]]
    --         vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine]]
    --         require 'indent_blankline'.setup {
    --             char = '▏',
    --             context_char = '▏',
    --             show_trailing_blankline_indent = false,
    --             space_char_blankline = ' ',
    --             show_current_context = true,
    --             show_current_context_start = true,
    --         }
    --     end,
    -- },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            -- 'hrsh7th/cmp-buffer',
            -- 'hrsh7th/cmp-path',
            -- 'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip',
            -- 'rafamadriz/friendly-snippets',
        },
        opts = function()
            local kind_icons = {
                Class = "󰠱",
                Color = "󰏘",
                Constant = "󰏿",
                Constructor = "",
                Enum = "",
                EnumMember = "",
                Event = "",
                Field = "󰇽",
                File = "󰈙",
                Folder = "󰉋",
                Function = "󰊕",
                Interface = "",
                Keyword = "󰌋",
                Method = "󰆧",
                Module = "",
                Operator = "󰆕",
                Property = "󰜢",
                Reference = "",
                Snippet = "",
                Struct = "",
                Text = "",
                TypeParameter = "󰅲",
                Unit = "",
                Value = "󰎠",
                Variable = "",
            }
            local cmp = require 'cmp'
            cmp.setup {
                snippet = {
                    expand = function(args)
                        vim.fn['vsnip#anonymous'](args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = {
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.close(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
                    ['<Down>'] = cmp.mapping.select_next_item(select_opts),
                    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
                    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'vsnip' },
                    -- { name = 'buffer' },
                },
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
                        -- vim_item.abbr = string.sub(vim_item.abbr, 1, 25)
                        vim_item.menu = ""
                        return vim_item
                    end
                },
            }
        end
    },
    -- {
    --     "ray-x/lsp_signature.nvim",
    --     opts = {
    --         fix_pos = false,
    --         floating_window = true,
    --         hint_enable = false,
    --         hint_prefix = "",
    --     },
    -- },
    --{
    --    'folke/noice.nvim',
    --    dependencies = {
    --        'MunifTanjim/nui.nvim',
    --        'rcarriga/nvim-notify',
    --    },
    --    opts = {
    --        cmdline = {
    --            enabled = false,        -- enables the Noice cmdline UI
    --            view = 'cmdline_popup', -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
    --            format = {
    --                -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
    --                -- view: (default is cmdline view)
    --                -- opts: any options passed to the view
    --                -- icon_hl_group: optional hl_group for the icon
    --                cmdline = { title = '', pattern = '^:', icon = '', lang = 'vim' },
    --                search_down = { title = '', kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
    --                search_up = { title = '', kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
    --                filter = { title = '', pattern = '^:%s*!', icon = '$', lang = 'bash' },
    --                lua = { title = '', pattern = '^:%s*lua%s+', icon = '', lang = 'lua' },
    --                help = { title = '', pattern = '^:%s*he?l?p?%s+', icon = '' },
    --                input = {}, -- Used by input()
    --                -- lua = false, -- to disable a format, set to `false`
    --            },
    --        },
    --        messages = {
    --            -- NOTE: If you enable messages, then the cmdline is enabled automatically.
    --            -- This is a current Neovim limitation.
    --            enabled = false,             -- enables the Noice messages UI
    --            view = 'mini',               -- default view for messages
    --            view_error = 'mini',         -- view for errors
    --            view_warn = 'mini',          -- view for warnings
    --            view_history = 'messages',   -- view for :messages
    --            view_search = 'virtualtext', -- view for search count messages. Set to `false` to disable
    --        },
    --        views = {
    --            cmdline_popup = {
    --                backend = 'popup',
    --                relative = 'editor',
    --                focusable = false,
    --                enter = false,
    --                zindex = 60,
    --                position = {
    --                    row = -2,
    --                    col = 0,
    --                },
    --                size = {
    --                    width = 'auto',
    --                    height = 'auto',
    --                },
    --                border = {
    --                    style = 'rounded',
    --                    padding = { 0, 0 },
    --                },
    --                win_options = {
    --                    winhighlight = {
    --                        Normal = 'NoiceCmdlinePopup',
    --                        FloatBorder = 'NoiceCmdlinePopupBorder',
    --                        IncSearch = '',
    --                        Search = '',
    --                    },
    --                    cursorline = false,
    --                },
    --            },
    --            mini = {
    --                align = 'message-left',
    --                reverse = false,
    --                timeout = 4000,
    --                position = {
    --                    row = -2,
    --                    col = '100%',
    --                    -- col = 0,
    --                },
    --                border = {
    --                    style = 'rounded',
    --                },
    --                win_options = {
    --                    winblend = 0,
    --                    winhighlight = {
    --                        FloatBorder = 'NoicePopupmenuBorder',
    --                    },
    --                },
    --            },
    --        },
    --        popupmenu = {
    --            enabled = false, -- enables the Noice popupmenu UI
    --            ---@type 'nui'|'cmp'
    --            backend = 'nui', -- backend to use to show regular cmdline completions
    --            ---@type NoicePopupmenuItemKind|false
    --            -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
    --            kind_icons = {}, -- set to `false` to disable icons
    --        },
    --        lsp = {
    --            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    --            override = {
    --                ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
    --                ['vim.lsp.util.stylize_markdown'] = true,
    --                -- ['cmp.entry.get_documentation'] = true,
    --            },
    --        },
    --        -- you can enable a preset for easier configuration
    --        presets = {
    --            bottom_search = false,         -- use a classic bottom cmdline for search
    --            -- command_palette = true, -- position the cmdline and popupmenu together
    --            long_message_to_split = false, -- long messages will be sent to a split
    --            inc_rename = false,            -- enables an input dialog for inc-rename.nvim
    --            lsp_doc_border = true,         -- add a border to hover docs and signature help
    --        },
    --        throttle = 1000 / 100,
    --    },
    --},
    {
        'folke/zen-mode.nvim',
        config = true,
    },
    {
        'rmagatti/goto-preview',
        lazy = false,
        config = function()
            require 'goto-preview'.setup {
                default_mappings = true,
            }
        end
    },

    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = lsp_cmds,
                desc = 'LSP actions',
                callback = function()
                    local bufmap = function(mode, lhs, rhs)
                        vim.keymap.set(mode, lhs, rhs, { buffer = true })
                    end

                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
                    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, bufopts)
                    vim.keymap.set('n', 'gl', vim.diagnostic.setloclist, bufopts)
                    vim.keymap.set('n', 'gh', vim.diagnostic.open_float, bufopts)
                    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
                    vim.keymap.set('n', '==', function() vim.lsp.buf.format { async = true } end, bufopts)
                end
            })
            local lspconfig = require 'lspconfig'
            local lsp_defaults = lspconfig.util.default_config

            -- Add LSP types to
            lsp_defaults.capabilities = vim.tbl_deep_extend('force', lsp_defaults.capabilities,
                require 'cmp_nvim_lsp'.default_capabilities())
        end,
    },
    {
        'williamboman/mason.nvim',
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'SmiteshP/nvim-navic',
            { 'folke/neodev.nvim', opts = { experimental = { pathStrict = true } } },

        },
        lazy = false,
        opts = {
            ensure_installed = {
                'gopls',
                'html-lsp',
                'lua-language-server',
                -- 'typescript-language-server',
                'pyright',
                'graphql-language-service-cli',
            },
        },
        config = function(plugin, opts)
            require 'mason'.setup(opts)
            require 'mason-lspconfig'.setup {}
            local mr = require 'mason-registry'
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end


            local function attach(client, bufnr)
                if client.server_capabilities.documentSymbolProvider then
                    require 'nvim-navic'.attach(client, bufnr)
                end
            end

            require 'mason-lspconfig'.setup_handlers {
                -- The first entry (without a key) will be the default handler
                -- and will be called for each installed server that doesn't have
                -- a dedicated handler.
                function(server_name) -- default handler (optional)
                    require 'lspconfig'[server_name].setup {
                        on_attach = attach
                    }
                end,

                -- ['tsserver'] = function()
                --     require'lspconfig'.tsserver.setup {
                --         on_attach = attach,
                --         -- root_dir = vim.loop.cwd,
                --         -- root_dir = require('lspconfig.util').root_pattern('.git'),
                --         root_dir = require('lspconfig.util').root_pattern("DISABLED-----"),
                --         init_options = {
                --             hostInfo = "neovim",
                --             maxTsServerMemory = 8096,
                --             completionDisableFilterText = true,
                --             disableAutomaticTypingAcquisition = true,
                --             -- tsserver = {
                --             --     logDirectory = "/Users/ben.seefeldt/tslogs/",
                --             --     logVerbosity = "verbose",
                --             -- },
                --         },
                --     }
                -- end,

                ['gopls'] = function()
                    require 'lspconfig'.gopls.setup {
                        on_attach = attach,
                        cmd = { 'gopls', 'serve' },
                        filetypes = { 'go', 'gomod' },
                        root_dir = require 'lspconfig/util'.root_pattern('go.work', 'go.mod', '.git'),
                        settings = {
                            gopls = {
                                codelenses = {
                                    test = true
                                },
                                analyses = {
                                    unusedparams = true,
                                },
                                -- memoryMode = "DegradeClosed",
                                staticcheck = true,
                            },
                        },
                    }
                end

            }
        end,
    },
    {
        'weilbith/nvim-code-action-menu', -- use command to open lsp actions selector
        cmd = 'CodeActionMenu',
    },
    -- {
    --     'kosayoda/nvim-lightbulb', -- Show a lightbulb where lsp actions are
    --     opts = {
    --         { autocmd = { enabled = true } }
    --     },
    -- },
    {
        'mbbill/undotree' -- Undo tree via UndotreeToggle
    },
    {
        'nvim-pack/nvim-spectre', -- enhanced search and replace.
        opts = {
            replace_engine = {
                ['sed'] = {
                    cmd = "gsed",
                    args = nil,
                    options = {
                        ['ignore-case'] = {
                            value= "--ignore-case",
                            icon="[I]",
                            desc="ignore case"
                        },
                    }
                }
            }
        },
    },
    {
        'gbprod/yanky.nvim',
        config = true,
    }
}

-- Set everything up
require 'lazy'.setup(plugins)
