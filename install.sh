#!/bin/bash
################################################################################
# 1. Symlinks dotfiles "dot_my_file" to $HOME/.my_file. Backups of existing
# files are created in $HOME/dotfiles_YYYY-MM-DD/.
#
# 2. Symlinks conf files (irssi, lubunturc) to $TARGET_DIR/my_conf_file. Backups
# of existing files are created as $TARGET_DIR/file_YYYY-MM-DD.
#
# 3. Creates a copy of localrc file to $HOME/.localrc if not already present.
#
# 4. Symlinks scripts (in scripts/) to $HOME/bin/my_script. Backups of existing
# files are created as $HOME/bin/my_script_YYYY-MM-DD.
#
# 5. Symlinks img/ dir to $HOME/.config/img/. Backup of existing img dir
# is created as $HOME/.config/img_YYYY-MM-DD.
################################################################################

TIME_STAMP=$(date +%F-%T) # date in format YYYY-MM-DD-HH:MM:SS
DOT_FILES_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

TARGET_DIR=$HOME # destination directory
BACKUP_DIR=$TARGET_DIR/dotfiles_$TIME_STAMP # old dotfiles backup directory

REQUIRED_PROGRAMS=(amixer angrysearch audacious compton galculator glipper
                   nautilus notify-send pacmd pactl pavucontrol rofi scrot skippy-xd synclient
                   x-tile xbacklight xrandr xscreensaver xscreensaver-command)

MISSING_PROGRAMS=()

check_command () {
    hash "$1" 2>/dev/null || { print_line >&2 "WARNING! $1 is not installed."; MISSING_PROGRAMS+=("$1"); }
}

deploy () {
    source=$1
    link=$2
    backup_place=$3

    mkdir --parents "$(dirname "$link")"

    if [ -L "$link" ]; then
        target=$(readlink "$link")
        if [ "$target" == "$source" ]; then
            return
        fi
        print_line "Deleting $link which is a link to $target ..."
        rm "$link"
    elif [ -e "$link" ]; then
        print_line "Moving $link to $backup_place ..."
        mv "$link" "$backup_place"
    fi

    print_line "Creating $link@ ..."
    ln --symbolic "$source" "$link"
}

print_line () {
    echo "[DOT FILES] $*"
}

############
# DOTFILES #
############

mkdir --parents "$BACKUP_DIR"

for file in $DOT_FILES_DIR/dot_*; do
    deploy "$file" "$TARGET_DIR/.$(echo basename "$file" | cut -d'_' -f 2-)" "$BACKUP_DIR"
done

# if no backup was made, delete backup dir
rmdir --ignore-fail-on-non-empty "$BACKUP_DIR"

# .localrc : copy if not present (no symlink)
cp --no-clobber "$DOT_FILES_DIR/localrc" "$TARGET_DIR/.localrc"

##############
# CONF FILES #
##############

deploy "$DOT_FILES_DIR/irssi_config" "$TARGET_DIR/.irssi/config" "$TARGET_DIR/.irssi/config_$TIME_STAMP"
deploy "$DOT_FILES_DIR/lubuntu-rc.xml" "$TARGET_DIR/.config/openbox/lubuntu-rc.xml" "$TARGET_DIR/.config/openbox/lubuntu-rc.xml_$TIME_STAMP"
deploy "$DOT_FILES_DIR/lubuntu-rc.xml" "$TARGET_DIR/.config/openbox/lxde-rc.xml" "$TARGET_DIR/.config/openbox/lxde-rc.xml_$TIME_STAMP"
deploy "$DOT_FILES_DIR/flake8" "$TARGET_DIR/.config/flake8" "$TARGET_DIR/.config/flake8_$TIME_STAMP"
deploy "$DOT_FILES_DIR/rofi_config" "$TARGET_DIR/.config/rofi/config" "$TARGET_DIR/.config/rofi/config_$TIME_STAMP"

###########
# SCRIPTS #
###########

for file in $DOT_FILES_DIR/scripts/*; do
    deploy "$file" "$TARGET_DIR/bin/$(basename "$file")" "$TARGET_DIR/bin/$(basename "$file")_$TIME_STAMP"
done

deploy "$DOT_FILES_DIR/img" "$TARGET_DIR/.config/img" "$TARGET_DIR/.config/img_$TIME_STAMP"

###############
# CHECK TOOLS #
###############

for cmd in "${REQUIRED_PROGRAMS[@]}"; do
    check_command "$cmd"
done

if [ ${#MISSING_PROGRAMS[@]} -gt 0 ]; then
    print_line "try running"
    print_line "sudo apt install" "${MISSING_PROGRAMS[@]}"
    print_line "to install missing programs."
fi
# EOF
