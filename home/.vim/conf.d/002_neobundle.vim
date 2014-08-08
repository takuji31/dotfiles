if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))
"NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc.vim', {'build' : {
                    \'mac' : 'make -f make_mac.mak',
                    \'unix' : 'make -f make_unix.mak',
                \},
            \}
NeoBundle 'Shougo/unite.vim'

