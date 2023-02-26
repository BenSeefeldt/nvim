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
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            vim.cmd([[colorscheme tokyonight-moon]])
        end,
    },
    {
        'ibhagwan/fzf-lua', -- Fuzzy Find
    },
    {
        'nvim-neo-tree/neo-tree.nvim', -- Tree navigation
        branch = 'v2.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
        },
        opts = {
            filesystem = {
                follow_current_file = true,
                window = {
                    mappings = {
                        ['g'] = 'grep',
                        ['G'] = 'grepsensitive',
                        ['f'] = 'fzffind',
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
                        require 'fzf-lua'.live_grep_glob({ cwd = path,
                            cmd = 'rg --column --line-number --no-heading --color=always ' })
                    end,
                },
            },
            source_selector = {
                winbar = true,
                statusline = false
            },
        },
    },
    {
        'nvim-lualine/lualine.nvim', -- custom status bar
        lazy = false,
        priority = 1000,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'SmiteshP/nvim-navic',
        },
        config = function()
            local navic = require 'nvim-navic'
            require 'lualine'.setup {
                options = {
                    icons_enabled = true,
                    path = 1,
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                },
                sections = {
                    lualine_a = { { 'mode', fmt = function(str) return str:sub(1, 1):lower() end } },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { 'filename' },
                    lualine_x = { 'encoding', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                tabline = {
                    lualine_a = {
                        function()
                            return ' ' .. os.date ' %a %m/%d/%y' .. ' -  ' .. os.date '%H:%M'
                        end
                    },
                    lualine_b = {
                        { navic.get_location, cond = navic.is_available },
                    },
                    lualine_c = {},
                    lualine_z = {
                        {
                            function()
                                hostname = vim.loop.os_gethostname()
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
                ensure_installed = {
                    'bash', 'help', 'html', 'javascript', 'json',
                    'lua', 'markdown', 'markdown_inline', 'python',
                    'query', 'regex', 'tsx', 'typescript', 'vim',
                    'yaml', 'kotlin', 'go', 'latex', 'bibtex',
                    'c', 'cpp', 'css', 'diff', 'elm', 'gitignore',
                    'git_rebase', 'gitattributes', 'gitcommit',
                    'graphql', 'gomod', 'make', 'sql', 'swift',
                    'terraform',
                },
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
        'chentoast/marks.nvim', -- adds gutter symbols for marks.
        opts = {
            default_mappings = false,
            builtin_marks = { '.', '<', '>', '^' },
            refresh_interval = 500,
        },
    },
    {
        'terrortylor/nvim-comment', -- quick toggle comment
        config = function()
            require 'nvim_comment'.setup()
        end,
    },
    {
        'kevinhwang91/nvim-bqf' -- better quick fix
    },
    {
        'folke/trouble.nvim', -- makes errors look nicer
        opts = {
            mode = 'document_diagnostics',
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
        },
    },
    {
        'lewis6991/gitsigns.nvim',
        config = true,
    },
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-rhubarb' },
    {
        'lukas-reineke/indent-blankline.nvim', -- Add colors to indent columns
        config = function()
            vim.cmd [[highlight IndentBlanklineContextStart guisp=#82aaff gui=underline]]
            vim.cmd [[highlight IndentBlanklineContextChar guifg=#82aaff gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine]]
            require 'indent_blankline'.setup {
                char = '▏',
                context_char = '▏',
                show_trailing_blankline_indent = false,
                space_char_blankline = ' ',
                show_current_context = true,
                show_current_context_start = true,
            }
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip',
        },
        opts = function()
            local kind_icons = {
                Text = '',
                Method = '',
                Function = '',
                Constructor = '',
                Field = '',
                Variable = '',
                Class = 'ﴯ',
                Interface = '',
                Module = '',
                Property = 'ﰠ',
                Unit = '',
                Value = '',
                Enum = '',
                Keyword = '',
                Snippet = '',
                Color = '',
                File = '',
                Reference = '',
                Folder = '',
                EnumMember = '',
                Constant = '',
                Struct = '',
                Event = '',
                Operator = '',
                TypeParameter = ''
            }
            local cmp = require 'cmp'
            cmp.setup {
                snippet = {
                    expand = function(args)
                        vim.fn['vsnip#anonymous'](args.body)
                    end,
                },
                mapping = {
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-f>'] = cmp.mapping.scroll_docs( -4),
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
                },
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
                        return vim_item
                    end
                },
            }
        end
    },
    {
        'folke/noice.nvim',
        dependencies = {
            'MunifTanjim/nui.nvim',
            'rcarriga/nvim-notify',
        },
        opts = {
            cmdline = {
                enabled = false, -- enables the Noice cmdline UI
                view = 'cmdline_popup', -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
                format = {
                    -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
                    -- view: (default is cmdline view)
                    -- opts: any options passed to the view
                    -- icon_hl_group: optional hl_group for the icon
                    cmdline = { title = '', pattern = '^:', icon = '', lang = 'vim' },
                    search_down = { title = '', kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
                    search_up = { title = '', kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
                    filter = { title = '', pattern = '^:%s*!', icon = '$', lang = 'bash' },
                    lua = { title = '', pattern = '^:%s*lua%s+', icon = '', lang = 'lua' },
                    help = { title = '', pattern = '^:%s*he?l?p?%s+', icon = '' },
                    input = {}, -- Used by input()
                    -- lua = false, -- to disable a format, set to `false`
                },
            },
            messages = {
                -- NOTE: If you enable messages, then the cmdline is enabled automatically.
                -- This is a current Neovim limitation.
                enabled = false, -- enables the Noice messages UI
                view = 'mini', -- default view for messages
                view_error = 'mini', -- view for errors
                view_warn = 'mini', -- view for warnings
                view_history = 'messages', -- view for :messages
                view_search = 'virtualtext', -- view for search count messages. Set to `false` to disable
            },
            views = {
                cmdline_popup = {
                    backend = 'popup',
                    relative = 'editor',
                    focusable = false,
                    enter = false,
                    zindex = 60,
                    position = {
                        row = -2,
                        col = 0,
                    },
                    size = {
                        width = 'auto',
                        height = 'auto',
                    },
                    border = {
                        style = 'rounded',
                        padding = { 0, 0 },
                    },
                    win_options = {
                        winhighlight = {
                            Normal = 'NoiceCmdlinePopup',
                            FloatBorder = 'NoiceCmdlinePopupBorder',
                            IncSearch = '',
                            Search = '',
                        },
                        cursorline = false,
                    },
                },
                mini = {
                    align = 'message-left',
                    reverse = false,
                    timeout = 4000,
                    position = {
                        row = -2,
                        col = '100%',
                        -- col = 0,
                    },
                    border = {
                        style = 'rounded',
                    },
                    win_options = {
                        winblend = 0,
                        winhighlight = {
                            FloatBorder = 'NoicePopupmenuBorder',
                        },
                    },
                },
            },
            popupmenu = {
                enabled = false, -- enables the Noice popupmenu UI
                ---@type 'nui'|'cmp'
                backend = 'nui', -- backend to use to show regular cmdline completions
                ---@type NoicePopupmenuItemKind|false
                -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
                kind_icons = {}, -- set to `false` to disable icons
            },
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    -- ['cmp.entry.get_documentation'] = true,
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = false, -- use a classic bottom cmdline for search
                -- command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = false, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true, -- add a border to hover docs and signature help
            },
            throttle = 1000 / 100,
        },
    },
    { 'gpanders/editorconfig.nvim' },
    {
        'rmagatti/goto-preview',
        lazy = false,
        config = function()
            require 'goto-preview'.setup {
                default_mappings = true
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
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
                    vim.keymap.set('n', 'gl', vim.diagnostic.setloclist, bufopts)
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
            { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },

        },
        lazy = false,
        config = function()
            require 'mason'.setup()
            require 'mason-lspconfig'.setup {}


            local function attach(client, bufnr)
                require 'nvim-navic'.attach(client, bufnr)
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
                                staticcheck = true,
                            },
                        },
                    }
                end

            }
        end,
    },
}

-- Set everything up
require 'lazy'.setup(plugins)
