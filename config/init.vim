" =============================================================================
" Neovim Configuration — VSCode/Cursor Replacement
" =============================================================================

" ---------------------------------------------------------------------------
" Plugin Manager (vim-plug)
" ---------------------------------------------------------------------------
call plug#begin('~/.local/share/nvim/plugged')

" --- File Tree (like VSCode sidebar) ---
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'              " file icons in tree
Plug 'Xuyuanp/nerdtree-git-plugin'        " git status in tree

" --- Autocomplete & LSP (like VSCode IntelliSense) ---
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" --- Fuzzy Finder (like Ctrl+P in VSCode) ---
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" --- Status Line ---
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" --- Git Integration ---
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" --- Editor Enhancements ---
Plug 'tpope/vim-commentary'               " gcc to comment
Plug 'tpope/vim-surround'                 " cs'" to change surrounds
Plug 'jiangmiao/auto-pairs'               " auto close brackets
Plug 'lukas-reineke/indent-blankline.nvim' " indentation guides

" --- Syntax & Language Support ---
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'sheerun/vim-polyglot'

" --- Color Scheme ---
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'folke/tokyonight.nvim'

" --- Terminal Integration (for agent CLI) ---
Plug 'akinsho/toggleterm.nvim', {'tag': '*'}
Plug 'github/copilot.vim'                 " AI completion (optional)

call plug#end()

" ---------------------------------------------------------------------------
" General Settings
" ---------------------------------------------------------------------------
set number                    " line numbers
set relativenumber            " relative line numbers
set mouse=a                   " mouse support
set clipboard=unnamedplus     " system clipboard

" Use OSC 52 for clipboard over SSH (sends yank to local terminal clipboard)
lua << EOF
if os.getenv("SSH_CONNECTION") then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
EOF
set termguicolors             " true color support
set signcolumn=yes            " always show sign column
set updatetime=300            " faster completion
set timeoutlen=400            " faster key sequence completion
set expandtab                 " spaces instead of tabs
set tabstop=2                 " 2 space tabs
set shiftwidth=2              " 2 space indentation
set softtabstop=2
set smartindent               " smart indentation
set wrap                      " wrap lines
set ignorecase                " case insensitive search
set smartcase                 " unless uppercase used
set cursorline                " highlight current line
set scrolloff=8               " keep 8 lines above/below cursor
set sidescrolloff=8
set hidden                    " allow hidden buffers
set nobackup                  " no backup files (CoC recommendation)
set nowritebackup
set cmdheight=2               " more space for messages
set shortmess+=c              " don't pass messages to ins-completion-menu
set splitbelow splitright      " natural split opening
set undofile                  " persistent undo
set completeopt=menuone,noinsert,noselect

" ---------------------------------------------------------------------------
" Color Scheme
" ---------------------------------------------------------------------------
set background=light
silent! colorscheme catppuccin-latte

" ---------------------------------------------------------------------------
" Key Mappings
" ---------------------------------------------------------------------------
let mapleader = " "           " space as leader key

" Save & Quit shortcuts (like Ctrl+S)
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa!<CR>

" Window navigation (Ctrl+hjkl like VSCode pane switching)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffer navigation (like tabs in VSCode)
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Clear search highlight
nnoremap <leader>h :nohlsearch<CR>

" Move lines up/down (like Alt+Up/Down in VSCode)
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Duplicate line (like Shift+Alt+Down in VSCode)
nnoremap <leader>d :t.<CR>

" Select all
nnoremap <C-a> ggVG

" ---------------------------------------------------------------------------
" NERDTree Configuration (File Explorer like VSCode sidebar)
" ---------------------------------------------------------------------------
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
nnoremap <C-b> :NERDTreeToggle<CR>

let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeIgnore = ['\.pyc$', '__pycache__', 'node_modules', '\.git$', '\.DS_Store']
let NERDTreeStatusline = ''
let NERDTreeWinSize = 25
" Auto-equalize splits so files get ~50% width when NERDTree is open
autocmd FileType nerdtree setlocal winfixwidth
set equalalways

function! BalanceWindowsPreserveTree()
  let cur = winnr()
  for w in range(1, winnr('$'))
    if getbufvar(winbufnr(w), '&filetype') ==# 'nerdtree'
      execute w . 'wincmd w'
      execute 'vertical resize ' . g:NERDTreeWinSize
      break
    endif
  endfor
  execute cur . 'wincmd w'
  wincmd =
endfunction

autocmd WinNew * call timer_start(10, {-> execute('call BalanceWindowsPreserveTree()')})

" Auto-close NERDTree if it's the last window
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Open NERDTree on startup if no file specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | NERDTree | endif

" ---------------------------------------------------------------------------
" CoC.nvim Configuration (Autocomplete / IntelliSense)
" ---------------------------------------------------------------------------
" Use Tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> accept selected completion item
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" GoTo code navigation (like F12 / Ctrl+Click in VSCode)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show documentation in preview window (like hover in VSCode)
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Symbol renaming (like F2 in VSCode)
nmap <leader>rn <Plug>(coc-rename)

" Code actions (like Ctrl+. in VSCode)
nmap <leader>ca <Plug>(coc-codeaction-cursor)
nmap <leader>cf <Plug>(coc-fix-current)

" Diagnostics navigation (like F8 in VSCode)
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" Format file (like Shift+Alt+F in VSCode)
nmap <leader>fm :call CocActionAsync('format')<CR>

" Organize imports
nmap <leader>oi :call CocActionAsync('organizeImport')<CR>

" Show all diagnostics
nnoremap <silent><nowait> <leader>di :<C-u>CocList diagnostics<cr>

" Search workspace symbols
nnoremap <silent><nowait> <leader>sy :<C-u>CocList -I symbols<cr>

" Highlight the symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" ---------------------------------------------------------------------------
" FZF Configuration (Fuzzy Finder like Ctrl+P)
" ---------------------------------------------------------------------------

" Source files first (respects .gitignore), then bazel output dirs.
" This ensures Ctrl+P shows source files at the top, with bazel-bin/
" bazel-out/bazel-testlogs files available further down the list.
if executable('fd')
  let $FZF_DEFAULT_COMMAND =
    \ 'fd --type f --hidden --follow --exclude .git;'
    \ . 'bdirs=""; for d in bazel-bin bazel-out bazel-testlogs bazel-genfiles; do'
    \ . ' [ -d "$d" ] && bdirs="$bdirs $d"; done;'
    \ . ' [ -n "$bdirs" ] && fd --type f --hidden --follow --no-ignore --exclude .git . $bdirs'
elseif executable('rg')
  let $FZF_DEFAULT_COMMAND =
    \ 'rg --files --hidden --follow --glob "!.git";'
    \ . 'for d in bazel-bin bazel-out bazel-testlogs bazel-genfiles; do'
    \ . ' [ -d "$d" ] && rg --files --hidden --follow --no-ignore --glob "!.git" "$d"; done'
else
  let $FZF_DEFAULT_COMMAND =
    \ 'find . -type f -not -path "*/.git/*" -not -path "*/bazel-*/*";'
    \ . 'for d in bazel-bin bazel-out bazel-testlogs bazel-genfiles; do'
    \ . ' [ -d "$d" ] && find "$d" -type f; done 2>/dev/null'
endif

nnoremap <C-p> :Files<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fc :Commits<CR>

let g:fzf_layout = { 'down': '~40%' }

" ---------------------------------------------------------------------------
" Airline Configuration (Status Bar)
" ---------------------------------------------------------------------------
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#coc#enabled = 1
let g:airline_powerline_fonts = 1

" ---------------------------------------------------------------------------
" GitGutter
" ---------------------------------------------------------------------------
let g:gitgutter_sign_added = '│'
let g:gitgutter_sign_modified = '│'
let g:gitgutter_sign_removed = '_'
let g:gitgutter_sign_removed_first_line = '‾'
let g:gitgutter_sign_modified_removed = '~'

" ---------------------------------------------------------------------------
" Terminal / ToggleTerm (for Agent CLI integration)
" ---------------------------------------------------------------------------
" Toggle terminal with Ctrl+` (like VSCode)
nnoremap <silent> <C-\> :ToggleTerm direction=horizontal size=15<CR>
tnoremap <silent> <C-\> <C-\><C-n>:ToggleTerm<CR>

" Easy escape from terminal mode
tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Named terminals for quick access
command! -nargs=0 AgentTerm :ToggleTerm direction=float size=20
nnoremap <leader>ta :AgentTerm<CR>
nnoremap <leader>tt :ToggleTerm direction=horizontal size=15<CR>
nnoremap <leader>tv :ToggleTerm direction=vertical size=80<CR>
nnoremap <leader>tf :ToggleTerm direction=float<CR>

" ---------------------------------------------------------------------------
" Auto Commands
" ---------------------------------------------------------------------------
" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Auto-save on leaving insert mode or cursor idle
autocmd InsertLeave,CursorHold * if &modified && filereadable(expand('%')) | silent! write | endif

" Return to last edit position when opening files
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Auto-reload files changed outside of Vim
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorMoved * checktime

" ---------------------------------------------------------------------------
" Lua Plugin Configurations
" ---------------------------------------------------------------------------
lua require('toggleterm-config')
lua require('treesitter-config')
