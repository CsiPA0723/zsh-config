# Remove path separator from WORDCHARS.
# WORDCHARS=${WORDCHARS//[\/]}

source ~/.config/zsh-config/options.zsh
source ~/.config/zsh-config/input.zsh
source ~/.config/zsh-config/colors.zsh

fpath=(~/.config/zsh-config/functions $fpath)
autoload -Uz ~/.config/zsh-config/functions/*


source ~/.config/zsh-config/modules.zsh
source ~/.config/zsh-config/utility/completion.zsh
source ~/.config/zsh-config/utility/fzf.zsh

source ~/.config/zsh-config/widgets.zsh
source ~/.config/zsh-config/aliases.zsh
source ~/.config/zsh-config/autocomp.zsh

# vim:fileencoding=utf-8
