# Zoxide
(( ${+commands[zoxide]} )) && eval "$(zoxide init zsh)"

[ -s "/usr/share/nvm/bash_completion" ] && . "/usr/share/nvm/bash_completion"

(( ${+commands[pnpm]} )) && eval "$(pnpm completion zsh)"

(( ${+commands[syncthing]} )) && eval "$(syncthing install-completions)"

# Load only on Laptop
if [[ $(uname -ar) = *"CsiPA-Arch"* ]]; then
  # Python pipx
  eval "$(register-python-argcomplete pipx)"

  # Load Angular CLI autocompletion.
  (( ${+commands[ng]} )) && eval "$(ng completion script)"
fi

# VCPKG
# NOTE: is bashcompinit needed??
[ -s "$HOME/.local/share/vcpkg/scripts/vcpkg_completion.zsh" ] && source $HOME/.local/share/vcpkg/scripts/vcpkg_completion.zsh

# vim:fileencoding=utf-8:foldmethod=marker
