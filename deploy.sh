#!/bin/bash
#####################################################################
# 1. Creates symlinks (in $HOME/) of all dotfiles found in dotfiles/
# (script’s directory). Backups of existing files are stored in
# $HOME/dotfiles_YYYY-MM-DD/
#
# 2. Creates symlinks of conf files (irssi, lubunturc) in TARGET_DIR.
# Backups of existing files are stored as TARGET_DIR/file_YYYY-MM-DD
#####################################################################

TIME_STAMP=`date +%Y-%m-%d` # date in format YYYY-MM-DD
DOT_FILES_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

TARGET_DIR=$HOME # destination directory
BACKUP_DIR=$TARGET_DIR/dotfiles_$TIME_STAMP # old dotfiles backup directory

deploy () {
	source_file=$1
	target_file=$2
	backup_place=$3

	# if target dir for config file does not exist, exit
	if [ ! -d $(dirname $target_file) ]; then
		echo "$(basename $target_file) : no directory $(dirname $target_file), aborting."
		return
	fi

	if [ -L $target_file ]; then
		TARGET=`readlink $target_file`
		if [ $TARGET == $source_file ]; then
			echo "$target_file is already a link to $TARGET"
			return
		fi
		echo "Deleting $target_file which is a link to $TARGET"
		rm $target_file
	elif [ -e $target_file ]; then
		echo "Moving $target_file to $backup_place"
		mv $target_file $backup_place
	fi
	# then create symlinks
	echo "Creating $target_file@"
	ln -s $source_file $target_file
}

deploy_dot_file () {
	source_file=$1
	stripped_source_file=`echo basename $source_file | cut -d'_' -f 2-`
	target_file=$TARGET_DIR/.$stripped_source_file
	deploy $source_file $target_file $BACKUP_DIR
}

deploy_config_file () {
	source_file="${DOT_FILES_DIR}/$1"
	target_file="$HOME/$2"
	backup_file="${target_file}_$TIME_STAMP"
	deploy $source_file $target_file $backup_file
}

#####################################################################

mkdir -p $BACKUP_DIR

# DOTFILES
for filename in $(ls -1 $DOT_FILES_DIR/dot_*); do
	deploy_dot_file $filename
done

# if no backup was made, delete backup dir
rmdir --ignore-fail-on-non-empty $BACKUP_DIR

# CONF FILES

# irssi
deploy_config_file irssi_config .irssi/config

# lubuntu-rc.xml
deploy_config_file lubuntu-rc.xml .config/openbox/lubuntu-rc.xml

# EOF
