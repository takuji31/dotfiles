nnoremap <silent> gs :<C-u>Agit<CR>
nnoremap <silent> gl :<C-u>AgitFile<CR>

autocmd FileType agit call s:my_agit_setting()
function! s:my_agit_setting()
  nmap <buffer> ch <Plug>(agit-git-cherry-pick)
  nmap <buffer> Rv <Plug>(agit-git-revert)
endfunction
