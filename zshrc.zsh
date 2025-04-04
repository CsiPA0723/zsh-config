# Remove path separator from WORDCHARS.
# WORDCHARS=${WORDCHARS//[\/]}

source $HOME/.config/zsh-config/options.zsh
source $HOME/.config/zsh-config/input.zsh
source $HOME/.config/zsh-config/colors.zsh

fpath=($HOME/.config/zsh-config/functions $fpath)
autoload -Uz $HOME/.config/zsh-config/functions/*

source $HOME/.config/zsh-config/utility/async.zsh
source $HOME/.config/zsh-config/prompt.zsh

source $HOME/.config/zsh-config/modules.zsh
source $HOME/.config/zsh-config/utility/completion.zsh
source $HOME/.config/zsh-config/utility/fzf.zsh

fpath=(~/.config/zsh-config/completions $fpath)

source $HOME/.config/zsh-config/widgets.zsh
source $HOME/.config/zsh-config/aliases.zsh
source $HOME/.config/zsh-config/autocomp.zsh

# vim:fileencoding=utf-8
