local vim_opts = {
    wrap = false,
    number = true,
    relativenumber = true,
    cursorline = true,
    cursorlineopt = 'both',
    ignorecase = true,
    smartcase = true,
    smartindent = true,
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
    foldtext = 'v:lua.Foldtext()',
    grepprg = 'rg --vimgrep',
    grepformat = vim.opt.grepformat ^ { '%f:%l:%c:%m' },
    -- splitbelow = true,
    -- splitright = true,
    -- list = true,
    -- listchars = [[tab:‣ ,trail:·,precedes:«,extends:»,eol:¬]]
}

for k, v in pairs(vim_opts) do
    vim.opt[k] = v
end

vim.cmd('filetype plugin indent on')

function Foldtext()
    local folded_line_num = vim.v.foldend - vim.v.foldstart
    local start_line = vim.fn.getline(vim.v.foldstart):gsub('\t',string.rep(' ', vim.opt.tabstop:get()))
    local end_line, _ = string.gsub(vim.fn.getline(vim.v.foldend), '%s+', '')
    return table.concat({
        -- '[' .. folded_line_num .. ']',
        -- '',
        start_line,
        '[' .. folded_line_num .. ']',
        end_line,
        '',
    }, ' ')
end

function Dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. Dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

-- This is the one
-- vim.uri_from_bufnr = function(_)
--   local output = vim.fn.system { 'realpath', '-s', vim.fn.expand('%') }
--   return "file://" .. output:gsub("^%s*(.-)%s*$", "%1")
-- end

-- local old_range_params = vim.lsp.util.make_given_range_params
--
-- vim.lsp.util.make_given_range_params = function (start_pos, end_pos)
--   -- before : file:///Users/ben.seefeldt/Projects/deleteme_vim_linking/folder1/folder1file1
--   -- after: file:///Users/ben.seefeldt/Projects/deleteme_vim_linking/folder2/folder1/folder1file1
--   local params = old_range_params(start_pos, end_pos)
--   -- print(dump(params))
--   --
--   -- local handle = io.popen("echo -h hello")
--   -- local result = handle:read("*a")
--   -- handle:close()
--   -- !realpath -s folder2//folder1//folder1file1
--   -- echo system('ls '..expand('%:h:S'))
--   local output = vim.fn.system { 'realpath', '-s', vim.fn.expand('%') }
--   params['textDocument'].uri = "file://" .. output
--   return params
-- end

local _border = "single"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = _border
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = _border
  }
)

vim.diagnostic.config{
  float={border=_border}
}
vim.opt.titlestring = [[%t%(\ %M%)%( (%{expand("%:~:.:h")})%)%(\ %a%)]]

