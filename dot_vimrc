
syntax on
set shiftwidth=4
set tabstop=4
set ignorecase nocompatible autoindent smartindent incsearch ruler 
colorscheme desert
syntax on
filetype plugin indent on
set nu
set showmatch
set ai
set et
set sw=2
set sts=2
set ts=8
set hls
colorscheme slate
set columns=140
set lines=35
set backup
set backupdir=~/.vim/backups
set hidden
map Q <Nop>

" Press Space to turn off highlighting and clear any message already
" displayed.
:nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
au BufNewfile,BufRead ~/.tmp/mutt*[0-9] set nobk nowb
" Activer la sauvegarde
set backup

" un historique raisonnable
set history=100

" undo, pour revenir en arrière
set undolevels=150

" Suffixes à cacher
set suffixes=.jpg,.png,.jpeg,.gif,.bak,~,.swp,.swo,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pyc,.pyo

" Backup dans ~/.vim/backup
if filewritable(expand("~/.vim/backup")) == 2
  " comme le répertoire est accessible en écriture,
  " on va l'utiliser.
  set backupdir=$HOME/.vim/backup
else
  if has("unix") || has("win32unix")
    " C'est c'est un système compatible UNIX, on
  " va créer le répertoire et l'utiliser.
    call system("mkdir $HOME/.vim/backup -p")
    set backupdir=$HOME/.vim/backup
  endif
endif

