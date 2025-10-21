typeset -U path PATH

# Load only on Laptop
if [[ $(uname -ar) = *"CsiPA-Arch"* ]]; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
  export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
  export PSTEST_PROFILE_LOAD='6b8359bb-63ba-45b3-bcf0-b7beb9cbffc6'
  export GH_TOKEN=$(gh auth token)

  export MANPATH=/usr/local/texlive/2013/texmf-dist/doc/man:$MANPATH
  export INFOPATH=/usr/local/texlive/2013/texmf-dist/doc/info:$INFOPATH
  path+=(/usr/local/texlive/2025/bin/x86_64-linux)
  path+=(~/.dotnet/tools)
fi

if [[ $(uname -ar) = *"crowsnest"* ]]; then
  export SERVER_CONFIG=true
  export GPG_TTY=$(tty)
fi

export PNPM_HOME="$HOME/.local/share/pnpm"
export NVM_DIR="$HOME/.nvm"
export BAT_THEME="Catppuccin Macchiato"
export MANPAGER="nvim +Man! "
export AUR_PAGER="yazi"

path=(~/.local/bin $path)
path=($PNPM_HOME $path)
export PATH

# vim:fileencoding=utf-8
