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
PROMPT=$RED'[%n@%m]'$YELLOW'[%d]'$CYAN'[Ruby:`ruby --version | cut -d " " -f 2`]'$MAGENTA'[Gem:`rvm gemset name | cut -d "/" -f 1`]'$GREEN' 
> '$WHITE

##### Set Env #####
export SHELL=zsh
export LANG=ja_JP.UTF-8
export LC_ALL=$LANG
export EDITOR=`which vim`
export LS_COLORS='di=01;36'
export KERNEL=`uname`
export PATH=$HOME/bin:/usr/local/bin:$HOME/.bundles/bin:$PATH
export SVN_EDITOR=$EDITOR
export LISTMAX=10000

export TERM="xterm-256color"

autoload -U colors
colors

autoload -U compinit
compinit

autoload -Uz zmv

zstyle ':completion:*:sudo:*' command-path $PATH
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:processes' command 'ps x'
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

#Git
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

setopt nocheckjobs

###### Tetris Settings #####
autoload -U tetris
zle -N tetris

###### zsh function Editor zed #####
autoload zed

###### Auto Completion Settings #####
_cache_hosts=(`perl -ne  'if (/^([a-zA-Z0-9.-]+)/) { print "$1\n";}' ~/.ssh/known_hosts`)

##### Set Shell Options #####
# タブで候補をトグルする
setopt auto_menu
# ディレクトリ名で移動
setopt auto_cd
# 自動修正機能
setopt correct
# ~$var でディレクトリにアクセス
setopt auto_name_dirs
# 接尾辞うぃ削除する
setopt auto_remove_slash
# 開始/終了タイムスタンプを書き込み
setopt extended_history
# 直前のヒストリと全く同じとき無視
setopt hist_ignore_dups
# 先頭がスペースで始まるとき無視
setopt hist_ignore_space
# プロンプト内で変数展開
setopt prompt_subst
# 重複するディレクトリを無視
setopt pushd_ignore_dups
# rm * を実行する前に確認
setopt rm_star_silent
# 行末のバッククウォートを無視
setopt sun_keyboard_hack
# W~^ を正規表現として扱う
setopt extended_glob
# ファイル種別を表す記号を末尾に表示
setopt list_types
# ベルを鳴らさない
setopt no_beep
# 無駄なスクロールを避ける
setopt always_last_prompt
# 先頭に ~ を付けたもので展開
setopt cdable_vars
# 変数内の文字列分解のデリミタ
setopt sh_word_split
# 変数名を保管する
setopt auto_param_keys
setopt share_history
setopt long_list_jobs
# val=expr でファイル名展開
setopt magic_equal_subst
# cd したら自動的に pushd する
setopt auto_pushd
setopt nonomatch

source ~/.zsh/script/cdd

function chpwd() {
  _reg_pwd_screennum
}

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
bindkey "^Q"    push-line-or-edit
bindkey "^R"    history-incremental-search-backword 

##### Set Aliases #####
alias cp='nocorrect cp'
alias mv='nocorrect mv'
alias rm='nocorrect rm'
alias mkdir='nocorrect mkdir'
alias gst='git status -s -b'
alias ls='ls --color'

# Suffix Aliases
alias -s txt='vi'
alias -s xml='vi'
alias -s log='tail -f'
alias -s tgz='tar zxvf'
alias -s tar.gz='tar zxvf'

alias screen="TERM=screen screen"

##### Set Functions #####
# Function For Screen
#function ssh_screen() {
#    cd $HOME
#    eval server=\${$#}
#    screen -U -t $server ssh "$@"
#    cd -
#}

function set_screen_window_title(){
  emulate -L zsh
  local -a cmd
  cmd=($argv)
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
      echo -n " k$cmd[1]: \\"
      return
      ;;
  esac

  local -A jtl jt=(${(kv)jobtexts})

  $cmd >>(read num rest
  cmd=(${(z)${(e):-\$jt$num}})
  echo -n " k$cmd[1]:t \\") 2>/dev/null
}
# screen window title set at exec command
#if [ $TERM = xterm-256color ]; then
#    chpwd () { echo -n "_`dirs`\\" }
#    preexec() {
#        # see [zsh-workers:13180]
#        # http://www.zsh.org/mla/workers/2000/msg03993.html
#        emulate -L zsh
#        local -a cmd; cmd=(${(z)2})
#        case $cmd[1] in
#            fg)
#                if (( $#cmd == 1 )); then
#                    cmd=(builtin jobs -l %+)
#                else
#                    cmd=(builtin jobs -l $cmd[2])
#                fi
#                ;;
#            %*) 
#                cmd=(builtin jobs -l $cmd[1])
#                ;;
#            cd)
#                if (( $#cmd == 2)); then
#                    cmd[1]=$cmd[2]
#                fi
#                ;&
#            *)
#/                echo -n "k$cmd[1]:t\\"
#                return
#                ;;
#        esac
#
#        local -A jt; jt=(${(kv)jobtexts})
#
#        $cmd >>(read num rest
#                 cmd=(${(z)${(e):-\$jt$num}})
#                 echo -n "k$cmd[1]:t\\") 2>/dev/null
#    }
#    chpwd
#fi
# GNU Screen AutoStart
#case "${TERM}" in
#  *xterm*|rxvt|(dt|k|E)term)
#    exec screen -U -D -xRR
#    ;;
#esac
#
#if [ `expr $TERM : screen` ]; then
#  alias ssh ssh_screen
#  precmd(){
#    screen -U -X title $(basename `echo $PWD | sed -e "s/ /_/g"`)
#  }
#  preexec(){
#    screen -U -X title `echo $1 | cut -d " " -f 1`
#  }
#fi

# rvm parameter
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# CVS parameter
zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
zstyle ':vcs_info:(svn:bzr):*' branchformat '%b:r&r'
zstyle ':vcs_info:bzr:*' use-simple true

autoload -Uz is-at-least
if is-at-least 4.3.10; then
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "+" 
  zstyle ':vcs_info:git:*' unstagedstr "-"
  zstyle ':vcs_info:git:*' formats '(%s)-[%b] %c%u'
  zstyle ':vcs_info:git:*' actionformats '(%s)-[%b|%a] %c%u'
fi

function _update_vcs_info_msg() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg
RPROMPT="%1(v|%F{green}%1v%f|)"

# 起動時256カラー表示
256colors2.pl

#case "${TERM}" in
#screen)
#    TERM=xterm
#    ;;
#esac

#case "${TERM}" in
#xterm|xterm-color)
#    export LSCOLORS=exfxcxdxbxegedabagacad
#    export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#    zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
#    ;;
#kterm-color)
#    stty erase '^H'
#    export LSCOLORS=exfxcxdxbxegedabagacad
#    export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#    zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
#    ;;
#kterm)
#    stty erase '^H'
#    ;;
#cons25)
#    unset LANG
#    export LSCOLORS=ExFxCxdxBxegedabagacad
#    export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#    zstyle ':completion:*' list-colors 'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
#    ;;
#jfbterm-color)
#    export LSCOLORS=gxFxCxdxBxegedabagacad
#    export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#    zstyle ':completion:*' list-colors 'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
#    ;;
#esac

# set terminal title including current directory
#case "${TERM}" in
#xterm|xterm-color|kterm|kterm-color)
#    precmd() {
#        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
#    }
#    ;;
#esac
