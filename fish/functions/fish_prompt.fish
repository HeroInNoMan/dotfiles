function fish_prompt -d "Write out the left hand side prompt"
  set -g RETVAL $status

  # Line 1
  begin_line '┌'
  prompt_credentials
  prompt_path
  available git; and prompt_git

  # Line 2
  begin_line '\n└'
  prompt_status

  prompt_super_user
  prompt_output
  set_color --bold white
  printf "→ "
  set_color normal
end

function prompt_super_user
  # if superuser (uid == 0)
  set -l uid (id -u $USER)
  if [ $uid -eq 0 ]
    set_color --bold white
    printf "("
    set_color yellow
    printf "⚡"
    set_color --bold white
    printf ")"
    set_color normal
  end
end

function prompt_output
  set_color --bold white
  printf "("
  set_color normal
  if test -n "$RETVAL" -a "$RETVAL" -ne 0
    set_color red
    printf "✘"
    set_color normal
  else
    set_color green
    printf "✔"
    set_color normal
  end
  set_color --bold white
  printf ")"
  set_color normal
end

function prompt_git -d "Display the current git state"
  set -l ref
  if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
    set ref (command git symbolic-ref HEAD 2> /dev/null)
    if [ $status -gt 0 ]
      set -l branch (command git show-ref --head -s --abbrev | head -n1 2> /dev/null)
      set ref "➦ $branch "
    end
    set branch_symbol \uE0A0
    set -l branch (echo $ref | sed  "s-refs/heads/-$branch_symbol -")

    set -l BG PROMPT
    set -l dirty (command git status --porcelain --ignore-submodules=dirty 2> /dev/null)
    if [ "$dirty" = "" ]
      set BG green
      set PROMPT "$branch"
    else
      set BG yellow
      set dirty ''

      # Check if there's any commit in the repo
      set -l empty 0
      git rev-parse --quiet --verify HEAD > /dev/null ^&1; or set empty 1

      set -l target
      if [ $empty = 1 ]
        # The repo is empty
        set target '4b825dc642cb6eb9a060e54bf8d69288fbee4904'
      else
        # The repo is not emtpy
        set target 'HEAD'

        # Check for unstaged change only when the repo is not empty
        set -l unstaged 0
        git diff --no-ext-diff --ignore-submodules=dirty --quiet --exit-code; or set unstaged 1
        if [ $unstaged = 1 ]; set dirty $dirty'●'; end
      end

      # Check for staged change
      set -l staged 0
      git diff-index --cached --quiet --exit-code --ignore-submodules=dirty $target; or set staged 1
      if [ $staged = 1 ]; set dirty $dirty'✚'; end

      # Check for dirty
      if [ "$dirty" = "" ]
        set PROMPT "$branch"
      else
        set PROMPT "$branch $dirty"
      end
    end
    printf " $PROMPT"
    # prompt_segment $BG black $PROMPT
  end
end

function prompt_credentials
  set_color --bold white
  printf '('
  set_color brgreen
  printf '%s' (whoami)
  set_color grey
  printf '@'
  set_color brblue
  printf '%s' (hostname|cut -d . -f 1)
  set_color --bold white
  printf ')'
  set_color normal
end

function prompt_status -d "active processes"
  set -l ACTIVE_JOBS (jobs | wc -l)
  if test "$ACTIVE_JOBS" -gt 0
    set_color --bold white
    printf '('
    set_color magenta
    printf "⚙$ACTIVE_JOBS"
    set_color --bold white
    printf ')'
    set_color normal
  end
end

function prompt_path
  set_color --bold white
  printf '('
  set_color --bold 74FF52
  printf (prompt_pwd)
  set_color --bold white
  printf ")"
  set_color normal
end

function begin_line -d ""
  set_color --bold white
  printf $argv[1]
  set_color normal
end

function available -a name -d "Check if a function or program is available."
  type "$name" ^/dev/null >&2
end

function prompt_segment -d "Function to draw a segment"
  set -l bg
  set -l fg
  if [ -n "$argv[1]" ]
    set bg $argv[1]
  else
    set bg normal
  end
  if [ -n "$argv[2]" ]
    set fg $argv[2]
  else
    set fg normal
  end
  if [ "$current_bg" != 'NONE' -a "$argv[1]" != "$current_bg" ]
    set_color -b $bg
    set_color $current_bg
    # echo -n "$segment_separator "
    set_color -b $bg
    set_color $fg
  else
    set_color -b $bg
    set_color $fg
    # echo -n " "
  end
  set current_bg $argv[1]
  if [ -n "$argv[3]" ]
    # echo -n -s $argv[3] " "
    echo -n -s $argv[3]
  end
end

function prompt_finish -d "Close open segments"
  if [ -n $current_bg ]
    set_color -b normal
    set_color $current_bg
    echo -n "$segment_separator "
  end
  set -g current_bg NONE
end

