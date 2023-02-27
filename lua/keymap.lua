function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

map('n', ';', ':')
map('n', ':', ':')

-- To close terms
map({'t'}, '<leader>q', '<cmd>ToggleTermToggleAll<CR>')

map('n', 'vv', '<C-w>v')
map('n', 'vs', '<C-w>s')

vim.api.nvim_create_user_command('JsonFormat', "execute '%!jq' | set filetype=json", {})

