local vim_opts = {
 
     wrap = false,
     number = true,
     relativenumber = true,
     cursorline = true,
     cursorlineopt = 'both',
     ignorecase = true,
     smartcase = true,
     wildmenu = true,
     wildmode = 'longest:full,full',
     termguicolors = true,
     title = true,
     cmdheight = 1,
     signcolumn = 'yes',
     showmatch = true,
     hidden = true,
     swapfile = false,
     scrolloff = 1,

     expandtab = true,
     tabstop = 4,
     shiftwidth = 4,
     softtabstop = 4,
     showmode = false,

     fillchars = 'fold: ',

     foldtext = "v:lua.foldtext()",

     -- splitbelow = true,
     -- splitright = true,
     -- list = true,
     -- listchars = [[tab:‣ ,trail:·,precedes:«,extends:»,eol:¬]]
}

for k, v in pairs(vim_opts) do
    vim.opt[k] = v
end

vim.cmd('filetype plugin indent on')

function foldtext()
  local folded_line_num = vim.v.foldend - vim.v.foldstart
  return table.concat({
    "[" .. folded_line_num .. "]",
      "",
    vim.fn.getline(vim.v.foldstart),
  }, " ")
end



