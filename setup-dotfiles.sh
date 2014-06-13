#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired
# dotfiles in ~/dotfiles
############################

########## Variables

DIR=~/dotfiles # dotfiles directory
OLD_DIR=~/dotfiles_old # old dotfiles backup directory
FILES="bash_aliases bashrc inputrc liquidpromptrc lynxrc muttrc profile tmux.conf vimrc" # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo "Creating $OLD_DIR for backup of any existing dotfiles in ~"
mkdir -p $OLD_DIR
echo "...done"

# change to the dotfiles directory
echo "Changing to the $DIR directory"
cd $DIR
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $FILES; do
    echo "Moving any existing dotfiles from ~ to $OLD_DIR"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $DIR/$file ~/.$file
done

# EOF
