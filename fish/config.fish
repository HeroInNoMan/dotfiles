# no greeting message
set fish_greeting

# configure timer
set -g fish_command_timer_export_cmd_duration_str 1
set -g fish_command_timer_color grey
set -g fish_command_timer_time_format ''
set -g fish_command_timer_millis 0
set -g fish_command_timer_threshold 1000

# load additional files
if test -f ~/.config/fish/functions/aliases.fish
  . ~/.config/fish/functions/aliases.fish
end

if test -f ~/.local.fish
  . ~/.local.fish
end

if test -f ~/.Xmodmap
  xmodmap ~/.Xmodmap
end

# set env variables
set -gx GTK_IM_MODULE xim
set -gx QT_IM_MODULE xim

set -gx EDITOR "emacsclient --alternate-editor= -nw"
set -gx PATH /usr/local/bin/ $HOME/bin $HOME/.local/bin/ $HOME/.screenlayout $PATH

# java stuff
set -gx PATH $JAVA_HOME/bin $PATH

function use-java-8
  set -gx JAVA_HOME $JAVA_8
end

# maven stuff
set -gx PATH $MAVEN_HOME/bin $PATH

function maven-debug
  mvn $argv -Drun.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"
end

function maven-eclipse
  mvn eclipse:configure-workspace -Declipse.workspace="$WORKSPACE" eclipse:clean eclipse:eclipse -Dwtpversion=1.5 $argv
end

function maven-install-eclipse
  mvn clean install $argv and mvn eclipse:configure-workspace -Declipse.workspace="$WORKSPACE" eclipse:clean eclipse:eclipse -Dwtpversion=1.5
end

# etags stuff
function update-etags
  [ -f TAGS ] and rm TAGS
  find . -name '*.java' -exec etags -a {} \;
end

# ~/.config/fish/config.fish
starship init fish | source

# icons in terminal
if test -f ~/.local/share/icons-in-terminal/icons.fish
  source ~/.local/share/icons-in-terminal/icons.fish
end

starship init fish | source

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# $SDKMAN_DIR must be defined in .localrc file
if  test -s $SDKMAN_DIR/bin/sdkman-init.sh
  bash $SDKMAN_DIR/bin/sdkman-init.sh
end
