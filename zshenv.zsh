typeset -U path PATH
typeset -U manpath MANPATH
typeset -U infopath INFOPATH

# Load only on Laptop
if [[ $(uname -ar) = *"CsiPA-Arch"* ]]; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
  export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
  export PSTEST_PROFILE_LOAD='6b8359bb-63ba-45b3-bcf0-b7beb9cbffc6'
  export npm_config_prefix="$HOME/.local"

  manpath+=(/usr/local/texlive/2025/texmf-dist/doc/man)
  infopath+=(/usr/local/texlive/2025/texmf-dist/doc/info)
  path+=(/usr/local/texlive/2025/bin/x86_64-linux)
fi

export BAT_THEME="Catppuccin Macchiato"
export MANPAGER="nvim +Man! "
export AUR_PAGER="yazi"

path=(~/.local/bin $path)
export PATH
export MANPATH
export INFOPATH

# vim:fileencoding=utf-8
