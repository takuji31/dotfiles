set runtimepath+=~/.config/nvim/

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath^=~/.config/nvim/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin(expand('~/.config/nvim/dein'))

" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')
call dein#add('Shougo/vimproc.vim', {'build': 'make'})



" Add or remove your plugins here:

" dein
call dein#add('haya14busa/dein-command.vim')


" unite
call dein#add('Shougo/unite.vim')
call dein#add('sgur/unite-git_grep')
call dein#add('tsukkee/unite-help')
call dein#add('tsukkee/unite-tag')
call dein#add('ujihisa/unite-colorscheme')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/neoyank.vim')
call dein#add('Shougo/unite-outline')

" completion
call dein#add('Shougo/deoplete.nvim')
call dein#add('Shougo/neco-vim')
call dein#add('c9s/perlomni.vim')

" snippets
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')

" git
call dein#add('tpope/vim-fugitive')
call dein#add('mattn/gist-vim')
call dein#add('airblade/vim-gitgutter')
call dein#add('cohama/agit.vim')

" editing
call dein#add('mattn/emmet-vim')
call dein#add('thinca/vim-qfreplace')
call dein#add('scrooloose/nerdcommenter.git')
call dein#add('othree/eregex.vim')
call dein#add('h1mesuke/vim-alignta')
call dein#add('AndrewRadev/switch.vim')
call dein#add('kana/vim-smartchr')
call dein#add('kannokanno/previm')

" help
call dein#add('thinca/vim-ref')
call dein#add('rizzatti/funcoo.vim')
call dein#add('rizzatti/dash.vim')

" tools
call dein#add('tyru/open-browser.vim')
call dein#add('thinca/vim-quickrun')
call dein#add('Shougo/vimfiler.vim')
call dein#add('Lokaltog/vim-easymotion')
call dein#add('rking/ag.vim')
call dein#add('editorconfig/editorconfig-vim')
call dein#add('tpope/vim-abolish')
call dein#add('modsound/gips-vim')


" filetype
call dein#add('Shougo/context_filetype.vim')
call dein#add('othree/html5.vim')
call dein#add('takuji31/xslate-vim')


" golang
call dein#add('dgryski/vim-godef')
call dein#add('fatih/vim-go')
call dein#add('nsf/gocode', {'rtp': 'vim/'})

" display
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')

"colorscheme
call dein#add('w0ng/vim-hybrid', {'merged': 0})


call dein#add('sudo.vim')

" You can specify revision/branch/tag.
"call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

" Required:
call dein#end()

" Required:
filetype plugin indent on

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

runtime! conf.d/*.vim
