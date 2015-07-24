set nocompatible
set background=dark
set tabstop=8
"set softtabstop=2
set shiftwidth=2
set smarttab
set expandtab
set backspace=2
set hlsearch
set number
set ruler
set nowrap
"set nowrapscan
set linebreak
set incsearch
set cursorline
set cursorcolumn
set ignorecase
"set spell spelllang=en_us
"set foldmethod=indent   " default foldlevel=1
"set textwidth=80
"set colorcolumn=81 " Need vim 7.3
syntax on
colorscheme darkblue

highlight CursorColumn ctermfg=white ctermbg=red
"highlight CursorLine cterm=bold

" back to the position last time opened
if has("autocmd")
  autocmd BufRead *.txt set tw=78
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal g'\"" |
  \ endif
endif

" highlight syntax for llvm
augroup filetype
  au! BufRead,BufNewFile *.ll     set filetype=llvm
  au! BufRead,BufNewFile *.td     set filetype=tablegen
  au! BufRead,BufNewFile *.cl     set filetype=c
  au! BufRead,BufNewFile *.def    set filetype=c
  au! BufRead,BufNewFile *.md     set filetype=rtl
  au! BufRead,BufNewFile *.c.*r.* set filetype=rtl  " GCC -fdump-rtl-all
  au! BufRead,BufNewFile *.c.*t.* set filetype=c    " GCC -fdump-tree-all
  au! BufRead,BufNewFile *.c      set filetype=cpp  " GCC has many C++ source but naming .c
  au! StdinReadPost *             set filetype=asm
augroup END

" Enable filetype detection
filetype on

" Optional
" C/C++ programming helpers
augroup csrc
  au!
  autocmd FileType *              set nocindent smartindent
  autocmd FileType c,cpp,python   set cindent
augroup END
" Set a few indentation parameters. See the VIM help for cinoptions-values for
" details.  These aren't absolute rules; they're just an approximation of
" common style in LLVM source.
set cinoptions=:0,g0,(0,Ws,l1

" LLVM Makefiles can have names such as Makefile.rules or TEST.nightly.Makefile,
" so it's important to categorize them as such.

" In Makefiles, don't expand tabs to spaces, since we need the actual tabs
autocmd FileType make set noexpandtab

" Trail Whitespace Highlight
highlight ExtraWhitespace ctermbg=gray guibg=darkgray
match ExtraWhitespace /\s\+$/
"autocmd ColorScheme * highlight ExtraWhitespace
" A dangerous way to force removing trailing whitespace
"autocmd BufWritePre * :%s/\s\+$//e

"" See difference between space and tab
"highlight Tab ctermbg=darkgray guibg=darkgray
"2match Tab /\t/   " at most 3 matches simultaneously
""autocmd ColorScheme * highlight Tab

" For python customized
"autocmd FileType python set tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType python set cinwords=if,elif,else,for,while,try,except,finally,def,class

" gvim color
"highlight Normal guibg=black guifg=grey

" copyright helper
map <F4> :call AddTitle()<CR>
function AddTitle()
    call append(0,"//==========================================================================//")
    call append(1,"// Copyright (c) 2013 Wen-Han Gu. All rights reserved.")
    call append(2,"//")
    call append(3,"// Author: Nowar Gu (Wen-Han Gu)")
    call append(4,"// E-mail: wenhan.gu <at> gmail.com")
    call append(5,"//")
    call append(6,"// Any advice is welcome. Thank you!")
    call append(7,"//==========================================================================//")
    echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
endfunction

" Load pathogen
call pathogen#infect()

" Open NERDTree automatically when no files specified
"autocmd vimenter * if !argc() | NERDTree | endif
" Close NERDTree automatically when the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

nmap <F7> :NERDTreeToggle<CR>
let g:NERDTreeMapOpenSplit = "s"
let g:NERDTreeMapOpenVSplit = "v"
let g:NERDTreeQuitOnOpen = 1

nmap <F8> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1

"" Rainbow parentheses plugin
"let g:rbpt_colorpairs = [
"    \ ['brown',       'RoyalBlue3'],
"    \ ['Darkblue',    'SeaGreen3'],
"    \ ['darkgray',    'DarkOrchid3'],
"    \ ['darkgreen',   'firebrick3'],
"    \ ['darkcyan',    'RoyalBlue3'],
"    \ ['darkred',     'SeaGreen3'],
"    \ ['darkmagenta', 'DarkOrchid3'],
"    \ ['brown',       'firebrick3'],
"    \ ['gray',        'RoyalBlue3'],
"    \ ['black',       'SeaGreen3'],
"    \ ['darkmagenta', 'DarkOrchid3'],
"    \ ['Darkblue',    'firebrick3'],
"    \ ['darkgreen',   'RoyalBlue3'],
"    \ ['darkcyan',    'SeaGreen3'],
"    \ ['darkred',     'DarkOrchid3'],
"    \ ['red',         'firebrick3'],
"    \ ]
"let g:rbpt_max = 16
"let g:rbpt_loadcmd_toogle = 0
"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces

set laststatus=2

" Put it on lastline, otherwise it won't work
" Seems pietty issue, but I don't know why...
set t_Co=256
