#!/bin/bash
################################################################################
# 1. Symlinks dotfiles "dot_my_file" to $HOME/.my_file. Backups of existing
# files are created in $HOME/dotfiles_backup_YYYY-MM-DD/.
#
# 2. Symlinks conf files (irssi, lubunturc) to $ROOT_TARGET_DIR/my_conf_file.
# Backups of existing files are created as $ROOT_TARGET_DIR/file_YYYY-MM-DD.
#
# 3. Creates a copy of localrc file to $HOME/.localrc if not already present.
#
# 4. Symlinks scripts (in scripts/) to $HOME/bin/my_script. Backups of existing
# files are created as $HOME/bin/my_script_YYYY-MM-DD.
#
# 5. Symlinks img/ dir to $HOME/.config/img/. Backup of existing img dir is
# created as $HOME/.config/img_YYYY-MM-DD.
################################################################################

TIME_STAMP=$(date +%F-%T) # date in format YYYY-MM-DD-HH:MM:SS
BACKUP_SUFFIX="_backup_${TIME_STAMP}"
DOT_FILES_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

ROOT_TARGET_DIR="$HOME" # destination directory
TARGET_CONF_DIR="${ROOT_TARGET_DIR}/.config" # destination directory
DEFAULT_BACKUP_DIR="${ROOT_TARGET_DIR}/dotfiles${BACKUP_SUFFIX}" # old dotfiles backup directory
EXTERNAL_REPOS_ROOT="$HOME/repos"

EXTERNAL_REPOS=("https://gitlab.com/vahnrr/rofi-menus.git"
                "https://github.com/mattydebie/bitwarden-rofi"
                "https://github.com/pawndev/rofi-autorandr.git"
                "https://github.com/eylles/dmenukaomoji.git"
                "https://github.com/ClydeDroid/rofi-bluetooth.git"
                "https://github.com/miroslavvidovic/rofi-scripts.git"
                "https://github.com/syl20bnr/spacemacs"
                "https://github.com/plexus/chemacs2.git")

PYTHON_PROGRAMS=(rofimoji)

EXTERNAL_PROGRAMS=(amixer
                   angrysearch
                   audacious
                   blueman-manager
                   compton
                   emacsclient
                   galculator
                   lxlock
                   lxpanelctl
                   lxsession-default
                   lxsession-logout
                   lxtask
                   lxterminal
                   nautilus
                   notify-send
                   openbox
                   pacmd
                   pactl
                   parcellite
                   pavucontrol
                   pcmanfm
                   rofi
                   scrot
                   skippy-xd
                   sleep
                   smplayer
                   synclient
                   x-tile
                   xbacklight
                   xkill
                   xrandr
                   xscreensaver
                   xscreensaver-command)

deploy () {
  # 1st param (mandatory) is the source file for which a symbolic link will be
  # created.
  #
  # 2nd param (optional) is the symbolic link to create. If not specified, use
  # the same directory sub-tree as the source and create the link there. The
  # root of the source sub-tree is $DOT_FILES_DIR, the root of the link sub-tree
  # is $TARGET_CONF_DIR.
  #
  # 3rd param (optional) is the path of the backup directory to create. If not
  # specified, create a directory named after the source file and add
  # $BACKUP_SUFFIX. The backup directory is created in the same location as the
  # symbolic link.
  #
  source=$1
  link=${2:-$TARGET_CONF_DIR/$(echo "$source" | sed "s,$DOT_FILES_DIR/,,")}
  backup_dir=${3:-$(dirname "$link")/$(basename "$link")${BACKUP_SUFFIX}}

  if [ -L "$link" ]; then
    target=$(readlink "$link")
    if [ "$target" == "$source" ]; then
      return
    fi
    print_line "Deleting $link which is a link to $target ..."
    rm "$link"
  elif [ -e "$link" ]; then
    print_line "Moving $link to $backup_dir ..."
    mkdir --parents "$backup_dir"
    mv "$link" "$backup_dir"
  fi

  print_line "Creating $link@ ..."
  mkdir --parents $(dirname "$link")
  ln --symbolic "$source" "$link"
}

print_line () {
  echo "[DOT FILES] $*"
}

install_dotfiles () {
  for file in $DOT_FILES_DIR/dot_*; do
    deploy "$file" "$ROOT_TARGET_DIR/.$(echo basename "$file" | cut -d'_' -f 2-)" "$DEFAULT_BACKUP_DIR"
  done
}

install_scripts () {
  for file in $(find $DOT_FILES_DIR | grep -e "/scripts\?/"); do
    deploy "$file" "$ROOT_TARGET_DIR/bin/$(basename "$file")"
  done
}

install_rofi_scripts () {
  deploy "$EXTERNAL_REPOS_ROOT/rofi-scripts/books-search/books-search.sh" "$ROOT_TARGET_DIR/bin/books-search.sh"
  chmod a+x "$ROOT_TARGET_DIR/bin/books-search.sh"

  deploy "$EXTERNAL_REPOS_ROOT/rofi-scripts/web-search.sh" "$ROOT_TARGET_DIR/bin/web-search.sh"
  chmod a+x "$ROOT_TARGET_DIR/bin/web-search.sh"
  sed -i 's|0 -p "|0 -selected-row 9 -theme "ale-run.rasi" -p "|' $EXTERNAL_REPOS_ROOT/rofi-scripts/web-search.sh

  deploy "$EXTERNAL_REPOS_ROOT/rofi-scripts/github-repos.sh" "$ROOT_TARGET_DIR/bin/github-repos.sh"
  chmod a+x "$ROOT_TARGET_DIR/bin/github-repos.sh"
  sed -i 's|custom -p "|custom -theme "ale-run.rasi" -p "|' $EXTERNAL_REPOS_ROOT/rofi-scripts/github-repos.sh
  sed -i 's|miroslavvidovic|heroinnoman|' $EXTERNAL_REPOS_ROOT/rofi-scripts/github-repos.sh
}

install_rofi_files () {
  for file in $(find $EXTERNAL_REPOS_ROOT/rofi-menus | grep -e "/scripts\?/"); do
    deploy "$file" "$ROOT_TARGET_DIR/bin/$(basename "$file")"
  done
  deploy "$DOT_FILES_DIR/rofi/themes/"     "$ROOT_TARGET_DIR/.local/share/rofi/themes"
  deploy "$EXTERNAL_REPOS_ROOT/rofi-menus" "$TARGET_CONF_DIR/rofi"
  rofi-utils set-colorscheme dark-steel-blue

  # fix minor stuff inside the external repo
  sed -i 's|#!/usr/bin/env python$|#!/usr/bin/env python3.9|' $EXTERNAL_REPOS_ROOT/rofi-menus/scripts/rofi-network
  sed -i 's|直|📶|' $EXTERNAL_REPOS_ROOT/rofi-menus/themes/network.rasi
}

install_rofi_bluetooth () {
  deploy "$EXTERNAL_REPOS_ROOT/rofi-bluetooth/rofi-bluetooth" "$ROOT_TARGET_DIR/bin/rofi-bluetooth"

  # add our own theme to the external command
  sed -i 's|\$\* -p"|$* -theme "ale-run.rasi" -p"|' $EXTERNAL_REPOS_ROOT/rofi-bluetooth/rofi-bluetooth
}

install_bw_rofi () {
  deploy "$EXTERNAL_REPOS_ROOT/bitwarden-rofi/bwmenu" "$ROOT_TARGET_DIR/bin/bitwarden-rofi"
}

install_localrc () {
  cp --no-clobber "$DOT_FILES_DIR/localrc" "$ROOT_TARGET_DIR/.localrc"
}

install_config_files () {
  deploy "$DOT_FILES_DIR/screenlayout/"          "$ROOT_TARGET_DIR/.screenlayout"
  deploy "$DOT_FILES_DIR/irssi_config"           "$ROOT_TARGET_DIR/.irssi/config"
  deploy "$DOT_FILES_DIR/openbox/lubuntu-rc.xml" "$TARGET_CONF_DIR/openbox/lxde-rc.xml"
  deploy "$DOT_FILES_DIR/openbox/lubuntu-rc.xml" "$TARGET_CONF_DIR/openbox/lxqt-rc.xml"
  deploy "$DOT_FILES_DIR/openbox/lubuntu-rc.xml" "$TARGET_CONF_DIR/openbox/rc.xml"
  deploy "$DOT_FILES_DIR/openbox/lubuntu-rc.xml"
  deploy "$DOT_FILES_DIR/flake8"
  deploy "$DOT_FILES_DIR/lxterminal/lxterminal.conf"
  deploy "$DOT_FILES_DIR/img"
  deploy "$DOT_FILES_DIR/fish/config.fish"
  deploy "$DOT_FILES_DIR/fish/functions"
  deploy "$DOT_FILES_DIR/fish/conf.d"
  deploy "$EXTERNAL_REPOS_ROOT/rofi-menus"       "$TARGET_CONF_DIR/rofi"
  deploy "$DOT_FILES_DIR/rofi/themes/"           "$ROOT_TARGET_DIR/.local/share/rofi/themes"
  deploy "$EXTERNAL_REPOS_ROOT/chemacs2"            "$ROOT_TARGET_DIR/.emacs.d"
}

check_missing_programmes () {
  MISSING_NATIVE_PROGRAMS=()
  MISSING_PYTHON_PROGRAMS=()
  for cmd in "${EXTERNAL_PROGRAMS[@]}"; do
    hash "$cmd" 2>/dev/null || { print_line >&2 "WARNING! $cmd is not installed."; MISSING_NATIVE_PROGRAMS+=("$cmd"); }
  done
  for cmd in "${PYTHON_PROGRAMS[@]}"; do
    hash "$cmd" 2>/dev/null || { print_line >&2 "WARNING! $cmd is not installed."; MISSING_PYTHON_PROGRAMS+=("$cmd"); }
  done

  if [[ ${#MISSING_NATIVE_PROGRAMS[@]} -gt 0 || ${#MISSING_PYTHON_PROGRAMS[@]} -gt 0 ]]; then
    print_line "try running"
    if [[ ${#MISSING_NATIVE_PROGRAMS[@]} -gt 0 ]]; then
      print_line "sudo apt install" "${MISSING_NATIVE_PROGRAMS[@]}"
    fi
    if [[ ${#MISSING_PYTHON_PROGRAMS[@]} -gt 0 ]]; then
      print_line "pip install" "${MISSING_PYTHON_PROGRAMS[@]}"
    fi
    print_line "to install missing programs."
  fi
}

clone_missing_repo () {
  old_dir=$(pwd)
  cd "$EXTERNAL_REPOS_ROOT" || return
  git clone "$1"
  cd "$old_dir" || return
}

check_missing_repos () {
  for repo in "${EXTERNAL_REPOS[@]}"; do
    [ ! -d "${EXTERNAL_REPOS_ROOT}/$(basename ${repo%.git})" ] && clone_missing_repo $repo
  done
}

function check_broken_links () {
  find "$ROOT_TARGET_DIR" -maxdepth 1 -xtype l > "broken_links_${TIME_STAMP}"
  [ -s "broken_links_${TIME_STAMP}" ] && echo "broken links:" && cat "broken_links_${TIME_STAMP}"
  rm "broken_links_${TIME_STAMP}"
}

main () {
  check_missing_repos
  check_missing_programmes
  install_dotfiles
  install_scripts
  install_rofi_files
  install_rofi_bluetooth
  install_rofi_scripts
  install_bw_rofi
  install_localrc
  install_config_files
  check_broken_links
}

main

# EOF
