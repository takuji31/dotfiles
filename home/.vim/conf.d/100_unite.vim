nnoremap <silent> ,f  :<C-u>Unite -buffer-name=git-ls git<CR>
nnoremap <silent> ,d  :<C-u>Unite -buffer-name=file file_rec/async<CR>
nnoremap <silent> ,b  :<C-u>Unite -buffer-name=myunite buffer file_mru file/new directory/new<CR>
nnoremap <silent> ,n  :<C-u>UniteWithBufferDir -buffer-name=new file/new directory/new<CR>
nnoremap <silent> ,y  :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> ,o  :<C-u>Unite -buffer-name=outline outline<CR>
nnoremap <silent> ,p  :<C-u>Unite -buffer-name=perldoc ref/perldoc<CR>
nnoremap <silent> ,s  :<C-u>Unite -buffer-name=source source<CR>
nnoremap <silent> ,h  :<C-u>Unite -buffer-name=help help<CR>
nnoremap <silent> ,i  :<C-u>Unite -buffer-name=neobundle neobundle/install:!<CR>
nnoremap <silent> ,l  :<C-u>Unite -buffer-name=lines line<CR>
nnoremap <silent> ,m  :<C-u>Unite -buffer-name=menu menu:shortcut<CR>
nnoremap <silent> ,v  :<C-u>Unite -buffer-name=mapping mapping<CR>
nnoremap <silent> ,;  :<C-u>Unite -buffer-name=commands command<CR>
nnoremap <silent> ,g  :<C-u>Unite -buffer-name=grep grep:.<CR>
nnoremap <silent> ,c  :<C-u>UniteWithBufferDir -buffer-name=file file<CR>

let g:unite_source_file_ignore_pattern = '\%(^\|/\)\.$\|\~$\|\.\%(o|exe|dll|bak|sw[po]\)$\|\%(^\|/\)blib\%($\|/\)'
let g:unite_source_file_rec_ignore_pattern = '\%(^\|/\)\.$\|\~$\|\.\%(o|exe|dll|bak|sw[po]\)$\|\%(^\|/\)blib\%($\|/\)\|\%(^\|/\)blib\%($\|/\)'
let g:unite_source_file_mru_ignore_pattern = '\~$\|\.\%(o|exe|dll|bak|sw[po]\)$\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)\|^\%(\\\\\|/mnt/\|/media/\|/Volumes/\)\|\%(^\|/\)\%(b\|ext\)lib\%($\|/\)'


let g:unite_source_file_mru_limit = 200
let g:unite_source_file_rec_max_depth = 10
let g:unite_enable_start_insert = 1

if !exists("g:unite_source_menu_menus")
    let g:unite_source_menu_menus = {}
endif

let g:unite_source_menu_menus.shortcut = {
\   "description" : "shortcut"
\}

" shortcut menus
let g:unite_source_menu_menus.shortcut.candidates = [
\   [ "vimrc", $HOME . "/.vimrc" ],
\   [ "gvimrc", $HOME . "/.gvimrc" ],
\   [ "Unite Beautiful Attack", "Unite -auto-preview colorscheme" ],
\]

function! g:unite_source_menu_menus.shortcut.map(key, value)
    let [word, value] = a:value

    if isdirectory(value)
        return {
\               "word" : "[directory] ".word,
\               "kind" : "directory",
\               "action__directory" : value
\           }
    elseif !empty(glob(value))
        return {
\               "word" : "[file] ".word,
\               "kind" : "file",
\               "default_action" : "tabdrop",
\               "action__path" : value,
\           }
    else
        return {
\               "word" : "[command] ".word,
\               "kind" : "command",
\               "action__command" : value
\           }
    endif
endfunction

" split window shortcut key
au FileType unite nnoremap <silent> <buffer> <expr> <C-s> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-s> unite#do_action('split')
au FileType unite nnoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
" tab shortcut key
au FileType unite nnoremap <silent> <buffer> <expr> <C-b> unite#do_action('tabopen')
au FileType unite inoremap <silent> <buffer> <expr> <C-b> unite#do_action('tabopen')

" go recursive
au FileType unite inoremap <silent> <buffer> <expr> <C-r> unite#do_action('rec')

" unite-grep and ag
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup'
let g:unite_source_grep_recursive_opt = ''
let g:unite_source_grep_max_candidates = 200
