function fish_prompt
  set -l last_status $status
  echo ""

  set --local cwd (
    string replace "$HOME" "~" "$PWD" |
    string split "/"
  )

  if test (count $cwd) -ge 4
    set short_cwd "$cwd[-3]/$cwd[-2]/$cwd[-1]"
  else
    set short_cwd (string join "/" $cwd)
  end
  
  if git rev-parse --git-dir > /dev/null 2>&1
    set --local branch (
      command git symbolic-ref --quiet HEAD 2> /dev/null |
      string replace "refs/heads/" ""
    )

    if test -z "(git status -s)"
      set _git_status "✔"

      echo (set_color blue)$short_cwd \
        (set_color green)$branch \
        $_git_status
    else
      set _git_status "✗"

      echo (set_color blue)$short_cwd \
        (set_color green)$branch \
        (set_color red) $_git_status
    end
  else
    set_color blue
    echo $short_cwd
  end
  
  if test $last_status -eq 0
    set_color magenta
  else
    set_color red
  end

  echo -n "❯ "

  set_color normal
end

funcsave fish_prompt

