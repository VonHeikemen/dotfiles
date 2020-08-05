# A modified version of this:
# https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/refined.zsh-theme

autoload -Uz vcs_info

local _current_dir="%{$fg[blue]%}%3~%{$reset_color%}"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*:*' formats "${_current_dir} %{$fg[green]%}%b"
zstyle ':vcs_info:*:*' nvcsformats "${_current_dir}" "" ""

# check if repo is dirty
git_dirty() {
    # Check if we're in a git repo
    command git rev-parse --is-inside-work-tree &>/dev/null || return

    if [ -z "$(git status -s)" ];then # it's "clean"
      echo "%{$fg[green]%}✔%{$reset_color%}"
    else
      echo "%{$fg[red]%}✗%{$reset_color%}"
    fi
}

# Display information about the current repository
repo_information() {
    echo "${vcs_info_msg_0_%%/.} $vcs_info_msg_1_$(git_dirty)"
}

# Output additional information about paths, repos and exec time
precmd() {
    vcs_info # Get version control info before we start outputting stuff
    print -P "\n$(repo_information)"
}

# Define prompts
PROMPT="%(?.%F{magenta}.%F{red})❯%f " # Display a red prompt char on failure
RPROMPT="%F{8}${SSH_TTY:+%n@%m}%f"    # Display username if connected via SSH

