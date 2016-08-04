"edit
set backspace=eol,indent,start

"indent
set cindent
set expandtab
set shiftwidth=4
set tabstop=4

"encoding
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,cp932
set fileformats=unix,dos,mac
set encoding=utf-8

"no backup swap files
set nobackup
set noswapfile

"search
set incsearch
set ignorecase
set smartcase
set showmatch

if &diff
    map <leader>1 :diffget LOCAL<CR>
    map <leader>2 :diffget BASE<CR>
    map <leader>3 :diffget REMOTE<CR>
endif
