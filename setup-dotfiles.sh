#!/bin/bash
#####################################################################
# This script creates symlinks in the $HOME directory of all dotfiles
# present in the script’s directory. Dotfiles already present in $HOME
# are backed up in a timestamped directory.
#####################################################################

TIME_STAMP=`date +%Y-%m-%d` # date in format YYYY-MM-DD
DOT_FILES_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
DOT_FILES="bash_aliases bashrc inputrc liquidpromptrc lynxrc muttrc profile tmux.conf vimrc"

TARGET_DIR=$HOME # destination directory
OLD_DIR=$TARGET_DIR/dotfiles_$TIME_STAMP # old dotfiles backup directory

echo "Creating backup directory: $OLD_DIR"
mkdir -p $OLD_DIR

# Backup existing dotfiles in TARGET_DIR to OLD_DIR
for filename in $DOT_FILES; do
	file=$TARGET_DIR/.$filename
	if [ -e $file ]; then
		echo "Moving $file to $OLD_DIR"
		mv $file $OLD_DIR
	fi

	# then create symlinks
	echo "Creating $file@"
    ln -s $DOT_FILES_DIR/$filename $file
done

# EOF
