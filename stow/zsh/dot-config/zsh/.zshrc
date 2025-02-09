source $ZDOTDIR/themes/theme-and-appearance.zsh
source $ZDOTDIR/themes/grep.zsh

#load completion
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select

#_comp_options+=(globdots) # With hidden files

#set emacs style keybinding -v for vim
bindkey -e

#set tmux-sessionizer keybind
bindkey -s ^f "tmux-sessionizer\n"

# Enable backward selection with Shift+Tab
bindkey '^[[Z' reverse-menu-complete

# Start typing + [Down-Arrow] - fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M emacs "^[[B" down-line-or-beginning-search

# Start typing + [Up-Arrow] - fuzzy find history forward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search

bindkey -M emacs "^[[A" up-line-or-beginning-search

#completion
#fpath=($ZDOTDIR/plugins/zsh-completions/src/ $fpath)

# fzf
source <(fzf --zsh)

#theme
fpath=($ZDOTDIR/themes/ $fpath)
autoload -Uz common; common

alias vi='nvim'
alias vim='nvim'
export EDITOR='nvim'
export GIT_EDITOR='nvim'
export VISUAL='nvim'

#linux
alias ls='ls --color=auto'

#macos
#alias ls='ls -G'
#alias diff='diff --color'
#export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#append command to history
setopt inc_append_history
#reload history whenever using it
setopt share_history

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end
