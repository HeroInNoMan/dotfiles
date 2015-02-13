dotfiles
========

This project keeps dotfiles (.bashrc, .gitconfig, .vimrc, .tmux.conf…) organized
in one directory under version control.

A install script creates symlinks of the dotfiles in the home directory. This
allows to restore a complete environnement quickly by cloning the project on a
new machine and launching “./deploy.sh”.

Dotfiles already present in the home directory are moved to a backup directory
named $HOME/dotfiles_YYYY-MM-DD-HH:MM:SS .

Additionally, some other config files (irssi, lubunturc) can also be deployed
(for each, the destination of the symlink must be given in the deploy.sh
script).

