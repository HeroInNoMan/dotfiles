#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired
# dotfiles in ~/dotfiles
############################

########## Variables

DIR=`dirname $0` # dotfiles directory
TARGET_DIR=$HOME # destination directory
OLD_DIR=$TARGET_DIR/dotfiles_old # old dotfiles backup directory
FILES="bash_aliases bashrc inputrc liquidpromptrc lynxrc muttrc profile tmux.conf vimrc" # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo "Creating backup dir $OLD_DIR"
mkdir -p $OLD_DIR

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for filename in $FILES; do
	file=$TARGET_DIR/.$filename
	if [ -e $file ]; then
		echo "Moving $file to $OLD_DIR."
		mv $file $OLD_DIR
	fi

	echo "Creating $file@."
    ln -s $DIR/$filename $file
done

# EOF
