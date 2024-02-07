
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
set expandtab
let mapleader  = ' '

nnoremap ; :
vnoremap ; :
nnoremap <leader>fs :w<cr>
nnoremap <leader>fq :q<cr>
nnoremap <leader>fQ :q!<cr>
nnoremap <leader>fww :wqa<cr>

inoremap <leader>jk <esc>
inoremap <leader>kj <esc>

nnoremap <leader>fed :tabe $HOME/profiles/vim/lite.vim<cr>
nnoremap <leader>fer :source $HOME/profiles/vim/lite.vim<cr>
nnoremap <leader>s   :%s/

nnoremap <leader>bl :b #<cr>
nnoremap <leader>bd :bd<cr>
