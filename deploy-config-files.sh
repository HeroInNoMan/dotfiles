#!/bin/bash
#####################################################################
# This script creates symlinks of various conf files, such as irssi
# conf file, lubunturc, and such. Conf files already present in the
# target directories are backed up by being renamed and timestamped.
#####################################################################

TIME_STAMP=`date +%Y-%m-%d` # date in format YYYY-MM-DD
DOT_FILES_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

function deploy_config_file {
	# ARG1: base name of the config file to deploy
	# ARG2: full name of the config file to replace

	NEW_FILE="${DOT_FILES_DIR}/$1"
	OLD_FILE="$HOME/$2"

	# if target dir for config file does not exist, exit
	if [ ! -d $(dirname $OLD_FILE) ]; then
		echo "$(basename $OLD_FILE) : no directory $(dirname $OLD_FILE), aborting."
		return
	fi

	BACKUP_FILE="${OLD_FILE}_$TIME_STAMP"

	# Backup existing conf files (or rm if symlink)
	if [ -L $OLD_FILE ]; then
		TARGET=`readlink $OLD_FILE`
		echo "Deleting $OLD_FILE which is a link to $TARGET"
		rm $OLD_FILE
	elif [ -e $OLD_FILE ]; then
		echo "Renaming $OLD_FILE to $BACKUP_FILE"
		mv $OLD_FILE $BACKUP_FILE
	fi
	# then create symlink
	echo "Creating $OLD_FILE@"
	ln -s $NEW_FILE $OLD_FILE
}

#####################################################################

# irssi
deploy_config_file irssi_config .irssi/config

# lubuntu-rc.xml
deploy_config_file lubuntu-rc.xml .config/openbox/lubuntu-rc.xml

# 

# EOF
