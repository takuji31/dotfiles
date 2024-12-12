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

autoload -Uz compinit
compinit

#ls color
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

#history
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000

ZSHHOME="${HOME}/.zsh"

if [ -d $ZSHHOME -a -r $ZSHHOME -a -x $ZSHHOME ]; then
    for i in $ZSHHOME/*; do
        [[ ${i##*/} = *.zsh ]] &&
            [ \( -f $i -o -h $i \) -a -r $i ] && . $i
    done
fi


#source local rc
[[ -e $HOME/.zshrc_local ]] && source $HOME/.zshrc_local

agent="$HOME/tmp/ssh-agent-$USER"
if [ -S "$SSH_AUTH_SOCK" ]; then
	case $SSH_AUTH_SOCK in
	/tmp/*/agent.[0-9]*)
		ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent
	esac
elif [ -S $agent ]; then
	export SSH_AUTH_SOCK=$agent
else
	echo "no ssh-agent"
fi

if [ -d "$HOME/.volta" ]; then
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"
fi
