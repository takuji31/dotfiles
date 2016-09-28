"swap move key bind
noremap j gj
noremap k gk
noremap gj j
noremap gk k

"escape search keyword
cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?  getcmdtype() == '?' ? '\?' : '?'

"search result keybind
nnoremap n  nzz
nnoremap N  Nzz

"select last edit text
nnoremap gc `[v`]
vnoremap gc :<C-u>normal gc<Enter>
onoremap gc :<C-u>normal gc<Enter>

" extend moving
source $VIMRUNTIME/macros/matchit.vim

nnoremap <ESC><ESC> :nohlsearch<CR><ESC>

"format json
map <Leader>j !python -m json.tool<CR>
"convert perl data to JSON
vnoremap ,j !perl -MJSON::PP -w -E 'binmode STDIN, ":utf8"; my @lines = <STDIN>; my $data = join "\n", @lines; say JSON::PP->new->utf8->canonical->pretty->encode(eval $data);'<CR>
