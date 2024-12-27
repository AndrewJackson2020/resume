
" Set relative and absolute line numbers
set number relativenumber

" Apply line numbering to netrw
let g:netrw_bufsettings = 'noma nomod nu nowrap ro nobl'

" Decleare plugins
call plug#begin()

  " Filetree plugin
  Plug 'preservim/nerdtree'

  " Theme plugin
  Plug 'morhetz/gruvbox'

  " LSP Plugin
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Need to set this in order for spellcheck to work
" Needs to be above 'colorscheme gruvbox' for some reason
let g:gruvbox_guisp_fallback = "bg" 

" Configure grubbox theme
colorscheme gruvbox
set background=dark
let g:gruvbox_transparant_bg = 1


" Ensure transparant terminal
highlight Normal     ctermbg=NONE guibg=NONE
highlight LineNr     ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE

" enable line numbers in NERDtree
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber

" Highlight all matched searches
set hlsearch

let g:markdown_fenced_languages = ['bash', 'yaml']

filetype plugin indent on
set tabstop=4
set shiftwidth=4

set spell spelllang=en_us
