# ----------------------------------
#  ZPLUG 
# ----------------------------------
export ZPLUG_HOME=~/.zplug
[[ -d $ZPLUG_HOME ]] || curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

if [[ -d $ZPLUG_HOME ]]; then
  source $ZPLUG_HOME/init.zsh
fi

zplug "zplug/zplug"

# THEME
zplug "yous/lime"

# COMMAND
zplug "stedolan/jq", \
  from:gh-r, \
  as:command, \
  rename-to:jq
zplug "b4b4r07/emoji-cli", \
  on:"stedolan/jq"
zplug "mrowa44/emojify", \
  as:command
zplug "motemen/ghq", \
  as:command, \
  from:gh-r
zplug "junegunn/fzf-bin", \
  as:command, \
  from:gh-r, \
  rename-to:fzf
zplug "junegunn/fzf", \
  as:command, \
  on:"junegunn/fzf-bin", \
  use:"bin/fzf-tmux"
zplug "ogham/exa", \
  from:gh-r, \
  as:command, \
  rename-to:exa, \
  use:"*macos*"

# EXTENSION
zplug "b4b4r07/enhancd", use:init.sh
zplug "mollifier/anyframe"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/zsh-completions"

zplug check --verbose || zplug install
zplug load 

# THEME Setting
export LIME_DIR_DISPLAY_COMPONENTS=2

# -------------------------------------
# zsh
# -------------------------------------

zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select=1

# 大文字小文字を区別せず補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完でカラー使用
autoload colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

# kill 候補に色付き表示
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

# sudo を付けても補完
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /

# もしかして
setopt correct

# No beep 
setopt no_beep

## 色を使う
setopt prompt_subst

# バックグラウンドジョブが終了したら通知
setopt no_tify

# 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

# 補完
# タブによるファイルの順番切り替えをしない
unsetopt auto_menu

# cd -[tab]で過去のディレクトリに移動
setopt auto_pushd

# -------------------------------------
# ALIAS
# -------------------------------------

# grep
alias grep="grep --color -I"

# ls
alias ls="exa"
alias la="ls -la"
alias ll="ls -l"
alias lg="ls -l --git"
alias tree="ls -T"

# mkdir
alias mkdir="mkdir -p"

alias dirs="dirs -plv"

# -------------------------------------
# ETC
# -------------------------------------

autoload -Uz vcs_info
autoload -Uz is-at-least

# iTerm2のタブ名を変更する
function title {
    echo -ne "\033]0;"$*"\007"
}

function ghq-fzf() {
  local src=$(ghq list --full-path | fzf --query "$LBUFFER")
  if [ -n "$src" ]; then
    BUFFER="cd $src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf
bindkey '^]' ghq-fzf

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
