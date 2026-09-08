# Initialize modules {{{

MODULE_FOLDER=${HOME}/.config/zsh-config/modules

local module_urls=(
  https://github.com/zdharma-continuum/fast-syntax-highlighting
  https://github.com/olets/zsh-abbr
  https://github.com/zsh-users/zsh-autosuggestions
  https://github.com/olets/zsh-autosuggestions-abbreviations-strategy
  https://github.com/zsh-users/zsh-completions
  https://github.com/zsh-users/zsh-history-substring-search
  https://github.com/olets/zsh-transient-prompt
)

zsh-install-modules() {
  if (( $+commands[git] )); then
    for url in ${module_urls}; do
     git clone "${url}" --recurse-submodules --single-branch --branch main --depth 1 "${MODULE_FOLDER}/${url##*/}"
    done
  else
    echo "Please install git to install the plugins"
  fi
}

zsh-update-modules() {
  if (( $+commands[git] )); then
    local _cwd=$(pwd)
    for url in ${module_urls}; do
      local module=${url##*/}
      echo "\nUpdating ${module}..."
      cd "${MODULE_FOLDER}/${module}"
      git pull --recurse-submodules --depth 1
    done
    cd ${_cwd}
  else
    echo "Please install git to update the plugins"
  fi
}

# ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# # Download zimfw plugin manager if missing.
# if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
#   if (( ${+commands[curl]} )); then
#     curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
#         https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
#   else
#     mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
#         https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
#   fi
# fi
# # Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
# if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
#   source ${ZIM_HOME}/zimfw.zsh init -q
# fi
# # Initialize modules.
# source ${ZIM_HOME}/init.zsh

# }}}

# Load modules {{{

source ${MODULE_FOLDER}/zsh-transient-prompt/transient-prompt.zsh-theme
source ${MODULE_FOLDER}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ${MODULE_FOLDER}/zsh-history-substring-search/zsh-history-substring-search.zsh
source ${MODULE_FOLDER}/zsh-abbr/zsh-abbr.zsh
source ${MODULE_FOLDER}/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${MODULE_FOLDER}/zsh-autosuggestions-abbreviations-strategy/zsh-autosuggestions-abbreviations-strategy.zsh

# Direnv module
eval "$(direnv hook zsh)"

# }}}

# Setup Modules {{{

# Load profiling module
zmodload zsh/zprof

# zsh-history-substring-search
zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key

# To suggest abbrevations before zsh-autosuggestions's default suggestions
ZSH_AUTOSUGGEST_STRATEGY=( abbreviations $ZSH_AUTOSUGGEST_STRATEGY )

# ZSH Abbr syntax highlighting integration {{{
chroma_single_word() {
  (( next_word = 2 | 8192 ))

  local __first_call="$1" __wrd="$2" __start_pos="$3" __end_pos="$4"
  local __style

  (( __first_call )) && { __style=${FAST_THEME_NAME}alias }
  [[ -n "$__style" ]] && (( __start=__start_pos-${#PREBUFFER}, __end=__end_pos-${#PREBUFFER}, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[$__style]}")

  (( this_word = next_word ))
  _start_pos=$_end_pos

  return 0
}

register_single_word_chroma() {
  local word=$1
  if [[ -x $(command -v $word) ]] || [[ -n $FAST_HIGHLIGHT["chroma-$word"] ]]; then
    return 1
  fi

  FAST_HIGHLIGHT+=( "chroma-$word" chroma_single_word )
  return 0
}

if [[ -n $FAST_HIGHLIGHT ]]; then
  for abbr in ${(f)"$(abbr list-abbreviations)"}; do
    if [[ $abbr != *' '* ]]; then
      register_single_word_chroma ${(Q)abbr}
    fi
  done
fi

# }}}

# zsh-completions
fpath=(${MODULE_FOLDER}/zsh-completions/src $fpath)

# }}}

# vim:fileencoding=utf-8:foldmethod=marker
