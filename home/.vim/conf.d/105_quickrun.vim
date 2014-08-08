nnoremap <Leader>q :<C-u>QuickRun -args<Space>
let g:quickrun_config = {}
let g:quickrun_config.mkd = {
\ 'outputter': 'browser',
\ 'type' : 'markdown/pandoc',
\ 'cmdopt' : '-s',
\ }
let g:quickrun_config.go = {
\ 'command': 'go',
\ 'exec': ['%c run %s']
\ }



