export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
export BAT_THEME="Catppuccin Macchiato"
export MANPAGER="nvim +Man! "
export PSTEST_PROFILE_LOAD='6b8359bb-63ba-45b3-bcf0-b7beb9cbffc6'
export AUR_PAGER="yazi"
export npm_config_prefix="$HOME/.local"

typeset -U path PATH
path=(~/.local/bin $path)
export PATH

# vim:fileencoding=utf-8
