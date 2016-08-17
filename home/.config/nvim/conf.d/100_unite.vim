
function! IsInsideWorkTree()
    let l:is_inside = system('git rev-parse --is-inside-work-tree')
    return l:is_inside == "true\n" ? 1 : 0
endfunction

function! UniteFileRecSource()
    if IsInsideWorkTree()
        Unite -buffer-name=git-ls file_rec/git:--cached:--others:--exclude-standard
    else
        Unite -buffer-name=file file_rec/neovim
    endif
endfunction

function! UniteFileGrepSource()
    if IsInsideWorkTree()
        Unite -buffer-name=git-grep grep/git:/:--cached
    else
        Unite -buffer-name=grep grep:.
    endif
endfunction



nnoremap    [unite]   <Nop>
nmap    f [unite]
xmap    f [unite]

nnoremap <silent> [unite]f  :<C-u>call UniteFileRecSource()<CR>
nnoremap <silent> [unite]b  :<C-u>Unite -buffer-name=myunite buffer file_mru file/new directory/new<CR>
nnoremap <silent> [unite]n  :<C-u>UniteWithBufferDir -buffer-name=new file/new directory/new<CR>
nnoremap <silent> [unite]y  :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]o  :<C-u>Unite -buffer-name=outline outline<CR>
nnoremap <silent> [unite]p  :<C-u>Unite -buffer-name=perldoc ref/perldoc<CR>
nnoremap <silent> [unite]s  :<C-u>Unite -buffer-name=source source<CR>
nnoremap <silent> [unite]h  :<C-u>Unite -buffer-name=help help<CR>
nnoremap <silent> [unite]l  :<C-u>Unite -buffer-name=lines line<CR>
nnoremap <silent> [unite]n  :<C-u>Unite -buffer-name=menu menu:shortcut<CR>
nnoremap <silent> [unite]v  :<C-u>Unite -buffer-name=mapping mapping<CR>
nnoremap <silent> [unite]g  :<C-u>call UniteFileGrepSource()<CR>
nnoremap <silent> [unite]c  :<C-u>UniteWithBufferDir -buffer-name=file file<CR>
nnoremap <silent> [unite]m  :<C-u>Unite output:message<CR>

noremap <silent> <C-]> :<C-u>Unite -no-start-insert tag:<C-r>=expand('<cword>')<CR><CR>

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings() "{{{
    "Overwrite settings.

    imap <buffer> jj      <Plug>(unite_insert_leave)

    imap <buffer><expr> j unite#smart_map('j', '')
    imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
    imap <buffer> '     <Plug>(unite_quick_match_default_action)
    nmap <buffer> '     <Plug>(unite_quick_match_default_action)
    imap <buffer><expr> x
          \ unite#smart_map('x', "\<Plug>(unite_quick_match_jump)")
    nmap <buffer> x     <Plug>(unite_quick_match_jump)
    nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
    imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
    nmap <buffer> <C-j>     <Plug>(unite_toggle_auto_preview)
    nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
    imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
    nnoremap <silent><buffer><expr> l
          \ unite#smart_map('l', unite#do_action('default'))

    let unite = unite#get_current_unite()
    if unite.profile_name ==# 'search'
    nnoremap <silent><buffer><expr> r     unite#do_action('replace')
    else
    nnoremap <silent><buffer><expr> r     unite#do_action('rename')
    endif

    nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
    nnoremap <buffer><expr> S      unite#mappings#set_current_sorters(
          \ empty(unite#mappings#get_current_sorters()) ?
          \ ['sorter_reverse'] : [])

    " Runs "split" action by <C-s>.
    nmap <silent><buffer><expr> <C-s> unite#do_action('split')
    imap <silent><buffer><expr> <C-s> unite#do_action('split')
    nmap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
    imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
    nmap <silent><buffer><expr> <C-b> unite#do_action('tabopen')
    imap <silent><buffer><expr> <C-b> unite#do_action('tabopen')
    imap <silent><buffer><expr> <C-r> unite#do_action('rec')

endfunction"}}}

let g:unite_source_file_ignore_pattern = '\%(^\|/\)\.$\|\~$\|\.\%(o|exe|dll|bak|sw[po]|gif|jpe?g|png|webp\)$\|\%(^\|/\)blib\%($\|/\)'
let g:unite_source_file_rec_ignore_pattern = '\%(^\|/\)\.$\|\~$\|\.\%(o|exe|dll|bak|sw[po]|gif|jpe?g|png|webp\)$\|\%(^\|/\)blib\%($\|/\)\|\%(^\|/\)blib\%($\|/\)'
let g:unite_source_file_mru_ignore_pattern = '\~$\|\.\%(o|exe|dll|bak|sw[po]|gif|jpe?g|png|webp\)$\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)\|^\%(\\\\\|/mnt/\|/media/\|/Volumes/\)\|\%(^\|/\)\%(b\|ext\)lib\%($\|/\)'


let g:unite_source_file_mru_limit = 200
let g:unite_source_file_rec_max_depth = 10

call unite#custom#profile('default', 'context', {
\   'start_insert': 1
\ })

if !exists("g:unite_source_menu_menus")
    let g:unite_source_menu_menus = {}
endif

let g:unite_source_menu_menus.shortcut = {
\   "description" : "shortcut"
\}

" shortcut menus
let g:unite_source_menu_menus.shortcut.candidates = [
\   [ "init.nvim", $HOME . "/.config/nvim/init.nvim" ],
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

" unite-grep and ag
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup'
let g:unite_source_grep_recursive_opt = ''
let g:unite_source_grep_max_candidates = 200
