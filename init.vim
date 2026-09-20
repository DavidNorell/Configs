""" Plugins
let g:ale_completion_enabled = 0
call plug#begin('~/.config/nvim/plugged')

""" UI
Plug 'altercation/vim-colors-solarized'
Plug 'nanotech/jellybeans.vim'
Plug 'sainnhe/everforest'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'kyazdani42/nvim-web-devicons'

""" Code utilities
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'bronson/vim-trailing-whitespace'
Plug 'folke/trouble.nvim'
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf', { 'dir': '~/source/fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lualine/lualine.nvim'

""" File utilities
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'build': ':TSUpdate', 'lazy': 'false'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'rhysd/git-messenger.vim' " Check out
Plug 'sindrets/diffview.nvim' " Check out
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'saghen/blink.cmp', { 'tag': 'v1.*' }
call plug#end()

""" Color
colorscheme gruvbox

if has("termguicolors")
    set termguicolors
endif

""" Leader
let mapleader = " "                       " space as leader
nnoremap <leader>ev :vsp    $MYVIMRC<cr>  " open init.vim in split
nnoremap <leader>sv :source $MYVIMRC<cr>  " source init.vim
nnoremap <leader>D :b#<bar>bd#<cr>
nnoremap <leader>o :LspClangdSwitchSourceHeader<cr>

noremap <leader>f :GFiles<CR>
noremap <leader>F :Telescope find_files<CR>
noremap <leader>l :Telescope find_files search_dirs=%:p:h<CR>
noremap <leader>b :Telescope buffers<CR>
noremap <leader>gg :Telescope live_grep<CR>
noremap <leader>j :cnext<CR>
noremap <leader>k :cprev<CR>

noremap <leader>x :Trouble diagnostics toggle focus=false filter.buf=0<CR>

""" LSP
lua << EOF
vim.lsp.config('hls', {})
vim.lsp.config('clangd', {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--query-driver=/Users/david/.espressif/tools/**/*-g++,/Users/david/.espressif/tools/**/*-gcc",
  }
})
vim.lsp.config('rust_analyzer', {})
vim.lsp.config('gopls', {})
vim.lsp.config('pylsp', {
settings = {
    pylsp = {
        plugins = {
            pylint = { enabled = false },
            mypy = { enabled = true },
            flake8 = { enabled = false },
            pycodestyle = { enabled = false },
            ruff = { enabled = true },
            isort = { enabled = true },
            },
        },
    },
})
vim.lsp.enable({'clangd', 'rust_analyzer', 'gopls', 'pylsp'})

-- Format on save
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    -- 2
    vim.api.nvim_create_autocmd("BufWritePre", {
      -- 3
      buffer = args.buf,
      callback = function()
        -- 4 + 5
        vim.lsp.buf.format {async = false, id = args.data.client_id }
      end,
    })
  end
})
EOF

nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>gd <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>gr :Telescope lsp_references<CR>
nnoremap <silent> <leader>gR :Trouble lsp_references<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>gk :Telescope lsp_document_symbols<CR>
nnoremap <silent> <leader>gw <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>ga <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>hh <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <silent> <leader>gf <cmd>lua vim.lsp.buf.format()<CR>

""" Blink
lua << EOF
require('blink.cmp').setup({
  keymap = { preset = 'default' },
  appearance = {
    nerd_font_variant = 'mono'
  },
  completion = {
    documentation = { auto_show = false }
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  fuzzy = {
    implementation = "prefer_rust_with_warning"
  }
})
EOF

""" Treesitter
lua << EOF
require'nvim-treesitter'.setup {
    ensure_installed = { "cpp", "c", "bash", "fish", "python", "lua", "vim", "vimdoc", "rust", "go" },
    highlight = {
        enable = true,
        disable = { "vimdoc", "vim", "help" },
    },
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
            selection_modes = {
                ['@function.outer'] = 'V',
                ['@class.outer'] = 'V',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>p"] = "@parameter.inner",
                ["<leader>a"] = "@argument.inner",
            },
            swap_previous = {
                ["<leader>P"] = "@parameter.inner",
                ["<leader>P"] = "@argument.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = { query = "@class.outer", desc = "Next class start" },
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
    },
}
require'treesitter-context'.setup {
  enable = true,
}
EOF

""" trouble
lua << EOF
require('trouble').setup()
EOF

""" Spaces and Tabs
set tabstop=2           " number of visual spaces per TAB
set softtabstop=2       " number of spaces in tab when editing
set shiftwidth=2      " number of spaces to use on << and >>
set expandtab           " tabs are spaces
set autoindent    " Copy indentation from current line on <cr>

""" Folding
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldmethod=expr   " use indent as fold indicator
set foldexpr=nvim_treesitter#foldexpr()

""" UI config
syntax on
set number            " show line numbers
set cursorline        " highlight current line
filetype plugin indent on
set wildmenu          " visual autocomplete for command menu
set lazyredraw        " redraw only when we need to
set showmatch         " highlight matching [{()}]
set diffopt+=vertical " Open diff window in vertical split
set scrolloff=2       " keep 3 lines above and below cursor

lua << END
require('lualine').setup {
  options = { theme = 'everforest' }
}
END


""" Searching
set incsearch      " search as characters are entered
set hlsearch       " highlight matches
set ignorecase     " Ignore case when searching
set smartcase      " Dont ignore case if typeing capital letters in search
if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
endif

nnoremap <leader>, :nohlsearch<cr>  " clear search highlight


""" Autocommands
autocmd WinEnter * set relativenumber     " set relativenumber when entering window
autocmd WinLeave * set norelativenumber   " set norelativenumber when entering window

""" Remaps
inoremap jk <Esc>
inoremap kj <Esc>

noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

noremap ]h :Gitsigns next_hunk<CR>
noremap [h :Gitsigns prev_hunk<CR>
noremap <leader>gh :Gitsigns preview_hunk<CR>

""" Misc
syntax enable
set guicursor=          " fix error with nvim printing strange character on entering insert mode
set virtualedit=block   " Enable to move cursor on places without characters in visual block mode
set clipboard=unnamedplus
