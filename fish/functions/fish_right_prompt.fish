function fish_right_prompt -d "Write out the right hand side prompt"
  # virtual env
  if set -q VIRTUAL_ENV
    set_color yellow
    printf "[%s]"  (basename "$VIRTUAL_ENV")
    set_color normal
  end

  # date & time
  set_color normal
  printf '['
  set_color 77ECF2
  #  printf (date "+%H:%M %a %d %b")
  printf (date "+%H:%M")
  set_color normal
  printf "]"
end
