alias sudo='sudo '

alias df='df -h'
alias du='du -h'

alias cat='bat '

alias zz='z -'

alias ssh='kitten ssh '

# alias ..="cd .." -- NOTE: not needed
alias ....="cd ../.."
alias ......="cd ../../.."

# Always wear a condom
alias chmod='chmod --preserve-root -v'
alias chown='chown --preserve-root -v'
if (( ${+commands[safe-rm]} && ! ${+commands[safe-rmdir]} )); then
  alias rm=safe-rm
fi

# -----------------------------
# Yazi
# -----------------------------

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# -----------------------------
# Eza
# -----------------------------

alias ls='eza --group-directories-first --icons --color=auto'
alias lsa='ls -A'
alias l='ls -lh --no-permissions'
alias la='l -A'
alias ll='ls -lh'
alias lla='ll -A'
alias lt='ll -sold'
alias lk='ll -Sr'
alias lm='l | less'
alias lr='ll -R'
alias lx='ll -X'

alias tree='eza --tree'


# -----------------------------
# File Downloads
# -----------------------------

# order of preference: aria2c, axel, wget, curl. This order is derrived from speed based on personal tests.
if (( ${+commands[aria2c]} )); then
  alias get='aria2c --max-connection-per-server=5 --continue'
elif (( ${+commands[axel]} )); then
  alias get='axel --num-connections=5 --alternate'
elif (( ${+commands[wget]} )); then
  alias get='wget --continue --progress=bar --timestamping'
elif (( ${+commands[curl]} )); then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
fi

# vim:fileencoding=utf-8
