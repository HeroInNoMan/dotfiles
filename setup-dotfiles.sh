#!/bin/bash
#####################################################################
# This script creates symlinks in the $HOME directory of all dotfiles
# present in the script’s directory. Dotfiles already present in $HOME
# are backed up in a timestamped directory.
#####################################################################

TIME_STAMP=`date +%Y-%m-%d` # date in format YYYY-MM-DD
DOT_FILES_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

TARGET_DIR=$HOME # destination directory
OLD_DIR=$TARGET_DIR/dotfiles_$TIME_STAMP # old dotfiles backup directory

echo "Creating backup directory: $OLD_DIR"
mkdir -p $OLD_DIR

# Backup existing dotfiles in TARGET_DIR to OLD_DIR
for filename in $( ls -1 $DOT_FILES_DIR/dot_*); do
	stripped_filename=`echo basename $filename | cut -d'_' -f 2-`
	file=$TARGET_DIR/.$stripped_filename
	if [ -e $file ]; then
		echo "Moving $file to $OLD_DIR"
		mv $file $OLD_DIR
	fi

	# then create symlinks
	echo "Creating $file@"
    ln -s $filename $file
done

# EOF
