#!/bin/bash
#####################################################################
# 1. Creates symlinks (in $HOME/) of all dotfiles found in dotfiles/
# (script’s directory). Backups of existing files are stored in
# $HOME/dotfiles_YYYY-MM-DD/
#
# 2. Creates symlinks of conf files (irssi, lubunturc) in TARGET_DIR.
# Backups of existing files are stored as TARGET_DIR/file_YYYY-MM-DD
#####################################################################

TIME_STAMP=$(date +%F-%T) # date in format YYYY-MM-DD-HH:MM:SS
DOT_FILES_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

TARGET_DIR=$HOME # destination directory
BACKUP_DIR=$TARGET_DIR/dotfiles_$TIME_STAMP # old dotfiles backup directory

deploy () {
	source=$1
	link=$2
	backup_place=$3

	if [ ! -d $(dirname $link) ]; then
		echo "$(basename $link) : no directory $(dirname $link), aborting."
		return
	fi

	if [ -L $link ]; then
		target=$(readlink $link)
		if [ $target == $source ]; then
			echo "$link is already a link to $target"
			return
		fi
		echo "Deleting $link which is a link to $target"
		rm $link
	elif [ -e $link ]; then
		echo "Moving $link to $backup_place"
		mv $link $backup_place
	fi

	echo "Creating $link@"
	ln -s $source $link
}

#####################################################################

mkdir -p $BACKUP_DIR

############
# DOTFILES #
############

for file in $(ls -1 $DOT_FILES_DIR/dot_*); do
	root_name=$(echo basename $file | cut -d'_' -f 2-)
	target=$TARGET_DIR/.$root_name
	deploy "$file" "$target" "$BACKUP_DIR"
done

# if no backup was made, delete backup dir
rmdir --ignore-fail-on-non-empty "$BACKUP_DIR"

##############
# CONF FILES #
##############

deploy "$DOT_FILES_DIR/irssi_config" "$TARGET_DIR/.irssi/config" "$TARGET_DIR/.irssi/config_$TIME_STAMP"
deploy "$DOT_FILES_DIR/lubuntu-rc.xml" "$TARGET_DIR/.config/openbox/lubuntu-rc.xml" ".config/openbox/lubuntu-rc.xml_$TIME_STAMP"

# .localrc : copy if not present (no symlink)
cp -n "$DOT_FILES_DIR/localrc" "$TARGET_DIR/.localrc"

###########
# SCRIPTS #
###########
mkdir -p $TARGET_DIR/bin

deploy "$DOT_FILES_DIR/scripts/manage-displays.sh" "$TARGET_DIR/bin/manage-displays.sh" "$TARGET_DIR/bin/manage-displays.sh_$TIME_STAMP"
deploy "$DOT_FILES_DIR/scripts/rofi-run.sh" "$TARGET_DIR/bin/rofi-run.sh" "$TARGET_DIR/bin/rofi-run.sh_$TIME_STAMP"
deploy "$DOT_FILES_DIR/scripts/sound-control.sh" "$TARGET_DIR/bin/sound-control.sh" "$TARGET_DIR/bin/sound-control.sh_$TIME_STAMP"
deploy "$DOT_FILES_DIR/scripts/switch_kb.sh" "$TARGET_DIR/bin/switch_kb.sh" "$TARGET_DIR/bin/switch_kb.sh_$TIME_STAMP"
deploy "$DOT_FILES_DIR/scripts/img" "$TARGET_DIR/.config/img" "$TARGET_DIR/.config/img_$TIME_STAMP"

# EOF
