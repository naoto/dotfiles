set nocompatible
filetype plugin indent off

set rtp+=~/.vim/vundle.git/
call vundle#rc()

"My Bundles here:
"
"original repos on github
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/vimfiler'
Bundle 'Shougo/vimproc'
Bundle 'Shougo/vimshell'
Bundle 'mattn/webapi-vim'
Bundle 'mattn/gal-vim'
Bundle 'thinca/vim-openbuf'
Bundle 'thinca/vim-showtime'
Bundle 'motemen/hatena-vim'
Bundle 'tsukkee/lingr-vim'
Bundle 'scrooloose/syntastic'
Bundle 'Lokaltog/vim-powerline'
Bundle 'myusuf3/numbers.vim'
Bundle 'glidenote/memolist.vim'

" vim-scripts repos
Bundle 'rails.vim'
Bundle 'RubySinatra'
Bundle 'ruby.vim'
Bundle 'Gist.vim'
Bundle 'quickrun.vim'
Bundle 'molokai'

" setting
set enc=utf-8
set fenc=utf-8
set fencs=utf-8,iso-2022-jp,euc-jp,cp932
set fileformats=unix,dos
set complete+=k
set visualbell
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set number
set wildmenu
set viminfo=
set nobackup
set noswapfile
set nowritebackup
set backspace=indent,eol,start
set directory=/tmp//
set listchars=tab:>_,trail:_,eol:↩
set list
set hlsearch
set iminsert=0
set imsearch=0
set ignorecase
set smartcase
set incsearch
set wrapscan
set ruler
set showcmd
set showmatch
set ambiwidth=double
set ww=31
set t_Co=256
set ttymouse=xterm2
set autoread

autocmd InsertLeave * set nopaste

set laststatus=2
set statusline=[%n]%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%m%r%w%=%{fugitive#statusline()}\ %l/%L:%c%V\ %3p%%

syntax on
filetype plugin indent on

highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=black
match ZenkakuSpace /　/

autocmd BufRead *.md :set ft=markdown
autocmd BufRead *.mkdn :set ft=markdown
autocmd BufRead *.mkd :set ft=markdown
autocmd BufRead *.ihtml :set ft=php
autocmd BufRead *.txt :set ft=markdown ff=dos
autocmd FileType php :set makeprg=php\ -l\ % errorformat=%m\ in\ %f\ on\ line\ %l
autocmd FileType php :set dictionary=$HOME/.vim/dictionary/php.dict
autocmd FileType ruby :set ts=2 sw=2 fenc=utf-8
autocmd FileType yaml :set fenc=utf-8
autocmd FileType css :set fenc=utf-8

set pumheight=15
hi Pmenu ctermbg=darkgray
hi PmenuSel ctermbg=blue
hi PmenuSbar ctermbg=white
hi TabLine ctermbg=white
hi TabLineSel ctermbg=red
hi TabLineFill ctermbg=white

" カーソル行をハイライト
 set cursorline
"
" " カーソル行を反転させる
 hi clear CursorLine
 hi CursoLine gui=underline
 highlight CursorLine term=reverse cterm=none ctermbg=234

"Color
colorscheme molokai
let g:molokai_original = 1

" for Hatena.vim
:set runtimepath+=$HOME/.vim/hatena
:let g:hatena_user='naoSora'

" for Gist.vim
:let g:github_user = 'naoto'
:let g:github_token = ''

" for lingr.vim
:let g:lingr_vim_user = 'naoto'
:let g:lingr_vim_password = ''

" for neocomplcache
"let g:neocomplcache_enable_at_startup = 1
"imap <C-k> <Plug>(neocomplcache_snippets_expand)
"smap <C-k> <Plug>(neocomplcache_snippets_expand)

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Enterを押したときに補完のポップアップを消す
inoremap <expr> <CR> pumvisible() ? "\<C-Y>\<CR>":"\<CR>"
" <TAB>で補完
function! InsertTabWrapper()
   let col = col('.') - 1
   if !col || getline('.')[col - 1] !~ '\k'
       return "\<TAB>"
   else
       if pumvisible()
           return "\<C-N>"
       else
           return "\<C-N>\<C-P>"
       end
   endif
endfunction

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

" syntastic
let g:syntastic_enable_signs  = 1
let g:syntastic_auto_loc_list = 2

" Powerline
let g:Powerline_symbols = 'fancy'

"Unite.vim 設定
noremap <C-U><C-B> :Unite buffer<CR>
noremap <C-U><C-F> :UniteWithBufferDir -buffer-name=files file<CR>
noremap <C-U><C-R> :Unite file_mru<CR>
noremap <C-U><C-Y> :Unite -buffer-name=register register<CR>
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
let g:unite_source_file_mru_filename_format = ''
let g:unite_winheight= 10

"VimFiler
noremap <C-F><C-F> :VimFiler -split -simple -winwidth=35 -no-quit<CR>
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_edit_action = 'split'
call vimfiler#set_execute_file('vim', 'vim')
call vimfiler#set_execute_file('txt', 'vim')

"memorist
noremap <C-M><C-N> :MemoNew<CR>
noremap <C-M><C-L> :MemoList<CR>
noremap <C-M><C-G> :MemoGrep<CR>
let g:memolist_path = "$HOME/.memolist"
let g:memolist_memo_suffix = "markdown"
let g:memolist_memo_date = "%Y-%m-%d %H:%M"
let g:memolist_memo_date = "epoch"
let g:memolist_memo_date = "%D %T"
let g:memolist_prompt_tags = 1
let g:memolist_prompt_categories = 0
let g:memolist_qfixgrep = 0
let g:memolist_vimfiler = 1
