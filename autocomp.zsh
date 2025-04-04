# KDE Logout function
fpath=(~/.config/zsh-config/completions $fpath)

# Zoxide
eval $(zoxide init zsh)

# Python pipx
eval "$(register-python-argcomplete pipx)"

# Load Angular CLI autocompletion.
source <(ng completion script)

# vim:fileencoding=utf-8:foldmethod=marker
