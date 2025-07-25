# Zoxide
eval "$(zoxide init zsh)"

[ -s "/usr/share/nvm/bash_completion" ] && . "/usr/share/nvm/bash_completion"

# Load only on Laptop
if [[ $(uname -ar) = *"CsiPA-Arch"* ]]; then
  # Python pipx
  eval "$(register-python-argcomplete pipx)"

  # Load Angular CLI autocompletion.
  eval "$(ng completion script)"
fi

# vim:fileencoding=utf-8:foldmethod=marker
