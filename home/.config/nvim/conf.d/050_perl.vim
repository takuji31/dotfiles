" perltidy
map ,p <Esc>:%! perltidy<CR>
vmap ,p <Esc>:'<,'>! perltidy<CR>

func! PerlPackageName()
  let path = substitute(expand("%:p"),"\\","/","g")
  let str  = substitute(path , '.*lib/\(.\+\)\.pm','\1', "")
  return substitute(str, "/", "::", "g")
endfunc
autocmd BufNewFile,BufRead *.psgi set filetype=perl
autocmd BufNewFile,BufRead *.t set filetype=perl
