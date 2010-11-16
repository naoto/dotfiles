##### Set Local Options #####
local BLACK=$'%{\e[00;47;30m%}'
local RED=$'%{\e[00;31m%}'
local GREEN=$'%{\e[00;32m%}'
local YELLOW=$'%{\e[00;33m%}'
local BLUE=$'%{\e[00;34m%}'
local MAGENTA=$'%{\e[00;35m%}'
local CYAN=$'%{\e[00;36m%}'
local WHITE=$'%{\e[00;37m%}'

##### Prompt Settings #####
PROMPT=$RED'[%n@%m]'$YELLOW'[%d]'$GREEN'
> '$WHITE

##### Set Env #####
export SHELL=zsh
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export PATH=$HOME/bin:/opt/local/bin:$HOME/code/:$PATH
export EDITOR=`which vim`
export SVN_EDITOR=$EDITOR
export PAGER=lv
export LISTMAX=10000
export LD_LIBRARY_PATH=/usr/local/lib
export LD_FLAGS=/usr/local/lib

#export RUBYPATH=/usr/lib/:/usr/local/lib
#export RUBYLIB=/usr/lib/ruby/1.8:/usr/lcaol/lib
#export GEM_HOME=/usr/lib/ruby/gems/1.8
export RUBYPATH=
export RUBYLIB=
export GEM_HOME=/home/naoto/.gem/ruby/1.8

setopt nocheckjobs

###### Auto Completion Settings #####
_cache_hosts=(`perl -ne  'if (/^([a-zA-Z0-9.-]+)/) { print "$1\n";}' ~/.ssh/known_hosts`)

autoload -U compinit
compinit

zstyle ':completion:*:sudo:*' command-path $PATH
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:processes' command 'ps x'
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

autoload -U colors
colors

###### Tetris Settings #####
autoload -U tetris
zle -N tetris

###### zsh function Editor zed #####
autoload zed

##### Set Shell Options #####
setopt auto_menu auto_cd correct auto_name_dirs auto_remove_slash
setopt extended_history hist_ignore_dups hist_ignore_space prompt_subst
setopt pushd_ignore_dups rm_star_silent sun_keyboard_hack
setopt extended_glob list_types no_beep always_last_prompt
setopt cdable_vars sh_word_split auto_param_keys share_history
setopt long_list_jobs magic_equal_subst auto_pushd

setopt nonomatch

##### History Settings #####
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

##### Keybind Settings #####
#bindkey -e # like emacs keybind
bindkey -v # like vi keybind
bindkey "^?"    backward-delete-char
bindkey "^H"    backward-delete-char
bindkey "^[[3~" backward-delete-char
bindkey "^[[3~" delete-char


##### Network Default Settings #####
#export http_proxy=""
#export HTTP_HOME="http://www.google.co.jp/"

##### Set Global Aliases #####
alias -g V='| vi -R -'
alias -g G='| grep '

##### Set Aliases #####
alias cp='nocorrect cp'
alias mv='nocorrect mv'
alias rm='nocorrect rm'
alias mkdir='nocorrect mkdir'

alias la='ls -lAh --color'
alias ls='ls -F --color'
alias ll='ls -lh --color'

# Subversion Aliases
alias svns='svn status'
alias svnr='svn revert'
alias svnp='svn propset svn:keywords Id'
alias svnd='svn diff'
alias mono='/usr/local/bin/mono'
# Application Aliases
alias w3m='w3m -B'

# Suffix Aliases
alias -s txt='vi'
alias -s xml='vi'
alias -s log='tail -f'
alias -s tgz='tar zxvf'
alias -s tar.gz='tar zxvf'

alias screen="TERM=screen screen -U"

function ssh_screen(){
  screen -X title $1
  ssh $1
}

##### Set Functions #####
# Function For Screen
function ssh_screen() {
    eval server=\${$#}
    screen -t $server ssh "$@"
}

# Google Search
function google() {
    local str opt
    if [ $# != 0 ]; then 
        for i in $*; do
            str="$str+$i"
        done
        str=`echo $str | sed 's/^\+//'`
        opt='search?num=50&hl=ja&ie=euc-jp&oe=euc-jp&lr=lang_ja'
        opt="${opt}&q=${str}"
    fi
    command w3m http://www.google.co.jp/$opt
}

# screen window title set at exec command
if [ $TERM = xterm-256color ]; then
    chpwd () { echo -n "_`dirs`\\" }
    preexec() {
        # see [zsh-workers:13180]
        # http://www.zsh.org/mla/workers/2000/msg03993.html
        emulate -L zsh
        local -a cmd; cmd=(${(z)2})
        case $cmd[1] in
            fg)
                if (( $#cmd == 1 )); then
                    cmd=(builtin jobs -l %+)
                else
                    cmd=(builtin jobs -l $cmd[2])
                fi
                ;;
            %*) 
                cmd=(builtin jobs -l $cmd[1])
                ;;
            cd)
                if (( $#cmd == 2)); then
                    cmd[1]=$cmd[2]
                fi
                ;&
            *)
                echo -n "k$cmd[1]:t\\"
                return
                ;;
        esac

        local -A jt; jt=(${(kv)jobtexts})

        $cmd >>(read num rest
                 cmd=(${(z)${(e):-\$jt$num}})
                 echo -n "k$cmd[1]:t\\") 2>/dev/null
    }
    chpwd
fi

# GNU Screen AutoStart
case "${TERM}" in
  *xterm*|rxvt|(dt|k|E)term)
    exec screen -U -D -xRR
    ;;
esac

if [ `expr $TERM : screen` ]; then
  alias ssh ssh_screen
  precmd(){
    screen -X title $(basename `echo $PWD | sed -e "s/ /_/g"`)
  }
  preexec(){
    screen -X title `echo $1 | cut -d " " -f 1`
  }
fi
