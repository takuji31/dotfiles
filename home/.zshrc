#Emacs keybind
bindkey -e

#history search
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey "^[[3~" delete-char # Del key
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end


# auto pushd when cd
setopt auto_pushd

#save extended history ex) time datetime
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history
#
#stop flow control
setopt no_flow_control
stty stop undef

setopt prompt_subst
setopt prompt_percent
setopt transient_rprompt

setopt extended_glob
setopt mark_dirs
setopt pushd_ignore_dups
setopt list_packed
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_save_nodups
setopt correct
setopt noautoremoveslash
setopt nolistbeep
setopt complete_aliases
setopt auto_menu
setopt list_types

autoload -U colors
colors
autoload -Uz zmv

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
