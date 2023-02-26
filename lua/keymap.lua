function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

map('n', ';', ':')
map('n', ':', ':')

map('n', '<leader>t', '<cmd>Neotree<CR>')
map('n', '<leader>p', '<cmd>TermExec direction="horizontal" size=15 cmd="cd %:p:h && go test"<CR>')
map({'n', 't'}, '<leader>1', '<cmd>ToggleTerm 1<CR>')
map({'n', 't'}, '<leader>2', '<cmd>ToggleTerm 2<CR>')
map({'n', 't'}, '<leader>3', '<cmd>ToggleTerm 3<CR>')
map({'n', 't'}, '<leader>4', '<cmd>ToggleTerm 4<CR>')
map('n', '<leader>g', '<cmd>FzfLua live_grep_glob<CR>')
map('n', '<leader>G', "<cmd>lua require'fzf-lua'.live_grep_glob({ cmd = 'rg --column --line-number --no-heading --color=always ' })<CR>", { noremap = true, silent = true })
map('n', '<leader>r', '<cmd>FzfLua live_grep_resume<CR>')
map('n', '<leader>w', '<cmd>FzfLua grep_cword<CR>')
map('n', '<leader>f', '<cmd>FzfLua files<CR>')
map('n', '<leader>b', '<cmd>FzfLua buffers<CR>')
map('n', '<leader>l', '<cmd>FzfLua blines<CR>')
map('n', '<leader>m', '<cmd>FzfLua marks<CR>')
map('n', '<leader>o', '<cmd>FzfLua oldfiles<CR>')

-- map('n', '<C-j>', '<C-w><C-j>')
-- map('n', '<C-k>', '<C-w><C-k>')
-- map('n', '<C-l>', '<C-w><C-l>')
-- map('n', '<C-h>', '<C-w><C-h>')
map('n', 'vv', '<C-w>v')
map('n', 'vs', '<C-w>s')

vim.api.nvim_create_user_command('JsonFormat', "execute '%!jq' | set filetype=json", {})

