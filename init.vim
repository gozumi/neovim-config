set number
" set relativenumber
set expandtab
set tabstop=2
set shiftwidth=2
set termguicolors

colorscheme peachpuff
" highlight FgCocErrorFloatBgCocFloating ctermbg=white guibg=white ctermfg=red guifg=red
" highlight FgCocHintFloatBgCocFloating ctermbg=white guibg=white
" highlight NormalFloat ctermbg=white guibg=white

let g:rustfmt_autosave = 1

" required for rust-lang/rust.vim
syntax enable
filetype plugin indent on

packadd minpac
call minpac#init()

call minpac#add('neovim/nvim-lspconfig')
call minpac#add('nvim-lua/plenary.nvim')
call minpac#add('nvim-telescope/telescope.nvim')
call minpac#add('k-takata/minpac', {'type':'opt'})
call minpac#add('neoclide/coc.nvim', {'branch': 'release'})
call minpac#add('rust-lang/rust.vim')
call minpac#add('cespare/vim-toml')
call minpac#add('hrsh7th/nvim-cmp')
call minpac#add('hrsh7th/vim-vsnip')
call minpac#add('hrsh7th/cmp-buffer')
call minpac#add('tpope/vim-surround')
call minpac#add('wfxr/minimap.vim')

let g:minimap_width = 10
let g:minimap_auto_start = 1
let g:minimap_auto_start_win_enter = 1


" this key map is taken from https://gist.github.com/zprhhs/9630dd6d666995236319afb35293a77b
" it maps the K key to the CocAction('doHover')
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

lua << EOF
local nvim_lsp = require('lspconfig')
local telescopeBuiltIn = require('telescope.builtin')
local set_keymap = vim.api.nvim_set_keymap

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

set_keymap('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>', {})
set_keymap('n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>', {})
set_keymap('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>', {})
set_keymap('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>', {})

EOF
