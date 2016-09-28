" TODO vim-airline の表示がdoubleだとぶっ壊れるのでやむなし
set ambiwidth=single
set t_Co=256
set background=dark
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1
colorscheme hybrid
set laststatus=2

"list mode
set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<

" highlight current line in current window
set cursorline
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END
highlight clear CursorLine
highlight CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black
