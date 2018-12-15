" colorscheme
if has("win32") || has("win64")
  colorscheme molokai
else
  colorscheme molokai
  syntax on
  set t_Co=256
endif

set number           " 行番号を表示
set relativenumber   " カーソル位置からの相対行番号を表示
set ruler            " カーソルの位置表示
set incsearch        " インクリメンタルサーチ
set hlsearch         " 検索語句のハイライト
set display=lastline " テキストが長すぎて表示しきれない場合でも表示する
set synmaxcol=200    " 1行あたりのシンタックス解析の文字数
set lazyredraw
set ttyfast

" 不可視文字の表示
set list
" 不可視文字を表示方法
set listchars=tab:>-,trail:-,eol:$,extends:>,precedes:<,nbsp:%

"全角スペースをハイライト表示"
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme       * call ZenkakuSpace()
    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
  augroup END
  call ZenkakuSpace()
endif

" vimgrepを行った時にQuickFixWindowを開く"
augroup grepopen
  autocmd!
  autocmd QuickfixCmdPost vimgrep cw
augroup END

" ファイルエンコーディングや文字コードを表示
set laststatus=2
set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=\ (%v,%l)/%L%8P\ 
