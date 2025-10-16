# Pacman hook {{{

zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

add-zsh-hook -Uz precmd rehash_precmd

# }}}

# Zoxide widget {{{

zoxide_run-cdi() {
  local dir="$(eval "zoxide query -i")"

  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi

  builtin cd -- ${(q)dir:a}
  zle .reset-prompt
	prompt_pure_async_tasks
  unset dir
}

zle -N zoxide_run-cdi
bindkey -M vicmd "^G" zoxide_run-cdi
bindkey -M viins "^G" zoxide_run-cdi

# }}}

# FZF .session.vim Project chooser {{{

fzf-project-widget() {
  setopt localoptions pipefail no_aliases 2> /dev/null

  local dir="$(
    FZF_DEFAULT_COMMAND="command fd --search-path=$HOME -H --no-ignore-vcs -E .git -td -tf --glob .session.vim | sed 's/\/\.session\.vim//g'" \
    FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --scheme=path --prompt='Sessions > ' --preview='eza -lhA --group-directories-first --icons --color=always --no-filesize --no-permissions --git {}'") \
    FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) < /dev/tty)"

  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  
  builtin cd -- ${(q)dir:a}
  zoxide add ${(q)dir:a}
  unset dir
  zle .reset-prompt
	prompt_pure_async_tasks
}

zle -N fzf-project-widget
bindkey -M vicmd "^F" fzf-project-widget
bindkey -M viins "^F" fzf-project-widget


# }}}

# Figures out where to get the best help, and gets it. Uses Zsh's provided run-help function.
# run-help {{{

if (( ! ${+HELPDIR} )); then
  local dir
  for dir in /usr/local/share/zsh/help /usr/share/zsh/${ZSH_VERSION}/help /usr/share/zsh/help; do
    if [[ -d ${dir} ]]; then
      typeset -g HELPDIR=${dir}
      break
    fi
  done
  unset dir
fi

unalias run-help 2>/dev/null
autoload -Uz run-help
bindkey '^[h' run-help
bindkey '^[H' run-help

local cmd
for cmd in git ip openssl p4 sudo svk svn; do
  if (( ${+commands[${cmd}]} )) autoload -Uz run-help-${cmd}
done
unset cmd

# }}}

if [[ -n "$KITTY_INSTALLATION_DIR" ]]; then
  export KITTY_SHELL_INTEGRATION="enabled"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

####
# ZSH function to auto-switch to correct Node version
#   https://gist.github.com/callumlocke/30990e247e52ab6ac1aa98e5f0e5bbf5
#
# - Searches up your directory tree for the closest .nvmrc, just like `nvm use` does.
#
# - If you are already on the right Node version, IT DOES NOTHING, AND PRINTS NOTHING.
#
# - Works correctly if your .nvmrc file contains something relaxed/generic,
#   like "4" or "v12.0" or "stable".
#
# - If an .nvmrc is found but you have no installed version that satisfies it, it
#   prints a clear warning, so you can decide whether you want to run `nvm install`.
#
# - If no .nvmrc is found, it does `nvm use default`.
# 
# Recommended: leave your default as something generic,
# e.g. do `nvm alias default stable`
####

use-nvmrc() {
  NVMRC_PATH=$(nvm_find_nvmrc)
  CURRENT_NODE_VERSION=$(nvm version)

  if [[ ! -z "$NVMRC_PATH" ]]; then
    # .nvmrc file found!

    # Read the file
    REQUESTED_NODE_VERSION=$(cat $NVMRC_PATH)

    # Find an installed Node version that satisfies the .nvmrc
    MATCHED_NODE_VERSION=$(nvm_match_version $REQUESTED_NODE_VERSION)

    if [[ ! -z "$MATCHED_NODE_VERSION" && $MATCHED_NODE_VERSION != "N/A" ]]; then
      # A suitable version is already installed.

      # Clear any warning suppression
      unset AUTOSWITCH_NODE_SUPPRESS_WARNING

      # Switch to the matched version ONLY if necessary
      if [[ $CURRENT_NODE_VERSION != $MATCHED_NODE_VERSION ]]; then
        nvm use $REQUESTED_NODE_VERSION
      fi
    else
      # No installed Node version satisfies the .nvmrc.

      # Quit silently if we already just warned about this exact .nvmrc file, so you
      # only get spammed once while navigating around within a single project.
      if [[ $AUTOSWITCH_NODE_SUPPRESS_WARNING == $NVMRC_PATH ]]; then
        return
      fi

      # Convert the .nvmrc path to a relative one (if possible) for readability
      RELATIVE_NVMRC_PATH="$(realpath --relative-to=$(pwd) $NVMRC_PATH 2> /dev/null || echo $NVMRC_PATH)"

      # Print a clear warning message
      echo ""
      echo "WARNING"
      echo "  Found file: $RELATIVE_NVMRC_PATH"
      echo "  specifying: $REQUESTED_NODE_VERSION"
      echo "  ...but no installed Node version satisfies this."
      echo "  "
      echo "  Current node version: $CURRENT_NODE_VERSION"
      echo "  "
      echo "  You might want to run \"nvm install\""

      # Record that we already warned about this unsatisfiable .nvmrc file
      export AUTOSWITCH_NODE_SUPPRESS_WARNING=$NVMRC_PATH
    fi
  else
    # No .nvmrc file found.

    # Clear any warning suppression
    unset AUTOSWITCH_NODE_SUPPRESS_WARNING

    # Revert to default version, unless that's already the current version.
    if [[ $CURRENT_NODE_VERSION != $(nvm version default)  ]]; then
      nvm use default
    fi
  fi
}

function auto-load-and-use-nvm() {
  if ! typeset -f nvm_find_nvmrc &> /dev/null; then
    # Load NVM
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  fi
  use-nvmrc
}

# Run the above function in ZSH whenever you change directory
add-zsh-hook chpwd auto-load-and-use-nvm
# if current directory has .nvmrc, call auto-load-and-use-nvm immediately
# [[ -f .nvmrc ]] && auto-load-and-use-nvm
auto-load-and-use-nvm

# vim:fileencoding=utf-8:foldmethod=marker
