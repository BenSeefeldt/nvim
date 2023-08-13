-- Swap command key
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', ':', ';')

-- Paste bindings
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<D-v>', '<C-\\><C-N>"+pi', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })

-- Custom user commands
vim.api.nvim_create_user_command('JsonFormat', "execute '%!jq' | set filetype=json", {})

-- Yanky Ring
vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")

local visual = {
    ['<leader>'] = {
        c = { '"*y', 'Copy to system clipboard' },
        o = { function ()
           local selection = require"fzf-lua.utils".get_visual_selection()
           local cmd = "open " .. selection
           vim.fn.system(cmd)
        end, 'Open in Browser'}
    },
    ['<space>'] = {
        g = { '<cmd>FzfLua grep_visual<CR>', 'Grep selection' },
        f = { '<cmd> lua require("fzf-lua").files(function() return {show_cwd_header=true, query=require"fzf-lua.utils".get_visual_selection()} end) <CR>', 'Find file by selection' },
    }
}
local term = {
    ['<leader>'] = {
        q = { '<cmd>ToggleTermToggleAll<CR>', 'Quit terms' },
        p = { '<c-\\><c-n><c-w><c-p>', 'Previous window' },
    }
}
local normal = {
    ['v'] = {
        v = { '<C-w>v', 'Vertical Split' },
        s = { '<C-w>s', 'Horizontal Split' },
    },
    ['<space>'] = {
        g = { '<cmd>FzfLua live_grep_glob<CR>', ' Grep' },
        G = {
            '<cmd>lua require"fzf-lua".live_grep_glob({ cmd = "rg --column --line-number --no-heading --color=always " })<CR>',
            ' C-S Grep',
        },
        w = { '<cmd>FzfLua grep_cword<CR>', ' Cursor Word' },
        a = { '<cmd>FzfLua lsp_code_actions<CR>', ' Code Actions' },
        f = { '<cmd>FzfLua files<CR>', ' Files' },
        b = { '<cmd>FzfLua buffers<CR>', ' Buffers' },
        d = { '<cmd>FzfLua diagnostics_document<CR>', ' Document Diagnostics' },
        l = { '<cmd>FzfLua blines<CR>', ' Lines' },
        m = { '<cmd>FzfLua marks<CR>', ' Marks' },
        o = { '<cmd>FzfLua oldfiles<CR>', ' Old Files' },
        q = { '<cmd>FzfLua quickfix<CR>', ' Quickfix entries' },
        s = { '<cmd>FzfLua lsp_document_symbols<CR>', ' Document Symbols' },
        r = { '<cmd>FzfLua resume<CR>', ' Resume' },
        t = { '<cmd>Neotree<CR>', ' NeoTree' },

    },
    ['<leader>'] = {
        l = { '<cmd>nohl<CR>', 'Clear highlight' },
        g = {
            name = ' Git',
            c = { '<cmd>topleft Gpedit <cword><CR>', 'Preview commit under cursor' },
            r = { '<cmd>.GBrowse<CR>', ' Browse' },
            b = { '<cmd>Git blame<CR>', ' Blame' },
            h = { '<cmd>0Gclog<CR>', 'File History' },
            v = { '<cmd>GitGutterPreviewHunk<CR>', ' View Diff' },
            d = { '<cmd>Gvdiffsplit<CR>', ' Diff' },
            l = { '<cmd>lua LazygitToggle()<CR>', ' LazyGit' },
            p = { '<cmd>!ghpr <cword><CR>', 'View PR' },
        },
        T = {
            name = "Terms",
            ['1'] = { '<cmd>ToggleTerm 1<CR>', ' Term 1' },
            ['2'] = { '<cmd>ToggleTerm 2<CR>', ' Term 2' },
            ['3'] = { '<cmd>ToggleTerm 3 size=20 direction=horizontal<CR>', ' Term 3' },
            ['4'] = { '<cmd>ToggleTerm 4 size=20 direction=horizontal<CR>', ' Term 4' },
            ['5'] = { '<cmd>ToggleTerm 5<CR>', ' Term 5' },
            ['6'] = { '<cmd>ToggleTerm 6<CR>', ' Term 6' },
            ['7'] = { '<cmd>ToggleTerm 7 size=40 direction=vertical<CR>', ' Term 7' },
            ['8'] = { '<cmd>ToggleTerm 8 size=40 direction=vertical<CR>', ' Term 8' },
            g = { '<cmd>TermExec direction="horizontal" size=15 cmd="cd %:p:h && go test"<CR>',
                ' Run Go Tests' },
        },
        a = { '<cmd>CodeActionMenu<CR>', ' Code Action Menu' },
        A = { '<cmd>lua vim.lsp.buf.code_action()<CR>', ' Code Action' },
        n = { '<cmd>!echo -n %:. | pbcopy<CR><CR>', 'Copy Filname' },
        f = { '<cmd>!open -R %<CR><CR>', ' Reveal in Finder' },
        j = { '<cmd>JsonFormat<CR>', ' Format Json' },
        e = { '<cmd>%!jq @json<CR>', ' Escape Json' },
        z = { '<cmd>ZenMode<CR>', ' ZenMode' },
        u = { '<cmd>UndotreeToggle<CR>', ' Undo Tree' },
        s = { '<cmd>Spectre<CR>', 'Spectre' },
        t = { '<cmd>Trouble<CR>', '! Trouble' },
        q = { [[<cmd>copen<CR>]], 'Show quickfix' },
        Q = {
            [[<cmd>call setqflist(map(getqflist(), 'extend(v:val, {"text":get(getbufline(v:val.bufnr, v:val.lnum),0)})'))<CR>]],
            'Refresh quickfix'
        },
        y = { '<cmd>YankyRingHistory<CR>', 'Yank Ring' },
    },
}

return {
    visual = visual,
    term = term,
    normal = normal,
}
