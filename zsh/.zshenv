export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
#export ZDOTDIR="$HOME/old_zsh/"

export HISTFILE=$ZDOTDIR/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

VIM='nvim'
export EDITOR=$VIM
export GIT_EDITOR=$VIM
export VISUAL=$VIM

export epitech="$HOME/Desktop/random/code/epitech"
