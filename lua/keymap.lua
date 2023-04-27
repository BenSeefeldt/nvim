function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Most keybinds can be found in `lua/plugins.lua` in `which-key` configuration.

-- Swap command key
map('n', ';', ':')
map('n', ':', ':')

-- Custom user commands
vim.api.nvim_create_user_command('JsonFormat', "execute '%!jq' | set filetype=json", {})
