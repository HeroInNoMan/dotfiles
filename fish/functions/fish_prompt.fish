function fish_prompt -d "Write out the left hand side prompt"
  set -g RETVAL $status

  # Line 1
  set_color --bold white
  printf '┌('
  # credentials
  set_color brgreen
  printf '%s' (whoami)
  set_color grey
  printf '@'
  set_color brblue
  printf '%s' (hostname|cut -d . -f 1)
  set_color --bold white
  printf ')'
  # active processes
  set -l ACTIVE_JOBS (jobs | wc -l)
  if test "$ACTIVE_JOBS" -gt 0
    set_color --bold white
    printf '('
    set_color magenta
    printf "$ACTIVE_JOBS"
    set_color --bold white
    printf ')'
    set_color normal
  end
  # path
  printf '('
  set_color --bold 74FF52
  printf (prompt_pwd)
  set_color --bold white
  printf ")"
  # vc info
  set_color FF3D3D
  printf "%s" (vcprompt -A ✚ -M \* -U \? --format '[%b %a%m%u]')
  set_color normal

  # Line 2
  set_color --bold white
  printf "\n└"
  # command output
  printf "("
  if test -n "$RETVAL" -a "$RETVAL" -ne 0
    set_color red
    printf "✘"
  else
    set_color green
    printf "✔"
  end
  set_color --bold white
  printf ")→ "
end


# printf '('
# set_color --bold 58FC92
# printf '%s files, ' (ls -1 | wc -l | sed 's: ::g')
# set_color --bold FAF734
# printf "total "
# set_color normal
# set_color white
# printf '%s' (ls -lah | grep -m 1 total | sed 's/total //')
# set_color --bold white
# printf ")"

