function fish_right_prompt -d "Write out the right hand side prompt"
  prompt_virtual_env
  prompt_date_time
  prompt_battery
end

function prompt_virtual_env
  if set -q VIRTUAL_ENV
    set_color yellow
    echo -n -s "[%s]"  (basename "$VIRTUAL_ENV")
    set_color normal
  end
end

function prompt_date_time
  set_color normal
  echo -n -s '['
  set_color 77ECF2
  #  echo -n -s (date "+%H:%M %a %d %b")
  echo -n -s (date "+%H:%M")
  set_color normal
  echo -n -s "]"
end

function prompt_battery
  set str (acpi | grep -oP 'Full|Charging|Discharging|\d+%|\d+:\d+' | tr --truncate-set1 '\n' ' ' | read charging percent time)

  if [ $charging = "Charging" ]
    set charging "cyan"
    set icon "↑"
  else if [ $charging = "Discharging" ]
    set gauge (echo $percent | cut -d% -f1)
    if [ $gauge -lt "15" ]
      set charging "red"
    else if [ $gauge -lt "50" ]
      set charging "yellow"
    else
      set charging "green"
    end
    set icon "↓"
  else
    return
  end

  set_color normal
  echo -n -s '['
  set_color $charging
  echo -n -s "$icon"
  # echo -n -s "$time"
  echo -n -s "$percent"
  set_color normal
  echo -n -s "]"
end
