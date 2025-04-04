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

  builtin cd -- ${(q)dir}
  zle .reset-prompt
	prompt_pure_async_tasks
  unset dir
}

zle -N zoxide_run-cdi
bindkey "^G" zoxide_run-cdi

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

# vim:fileencoding=utf-8:foldmethod=marker
