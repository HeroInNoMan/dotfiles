#!/usr/bin/env bash

###############################################################################
#        This script adds a WTFPL license file to the current project.        #
###############################################################################

# goto project root ###########################################################
old_dir=$PWD
ROOT_DIR=$(git rev-parse --show-toplevel)
cd $ROOT_DIR
# write license file ##########################################################
cat >LICENSE <<EOL
              DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE
                         Version 3.1, July 2019
                     https://ph.dtf.wtf/u/wtfplv31

by Arthur Léothaud <arthur@leothaud.eu>

              DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

0. You just DO WHAT THE FUCK YOU WANT TO.
EOL

# go back to old_dir ##########################################################
cd $old_dir
