DOTDIR=~/dotfiles

# KEY BINDING
bindkey -e

# PATH
# 重複要素を自動的に排除
typeset -gx -U path cdpath fpath manpath

path=(
    $HOME/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

fpath=(
    ~/.zsh/completion(N-/)
    ~/.zsh/functions(N-/)
    ~/.zsh/plugins/zsh-completions(N-/)
    /usr/local/share/zsh/site-functions(N-/)
    $fpath
)

# LANGUAGE
export LANGUAGE="en_US.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"

# EDITOR
if (( $+commands[vim] )); then
  export EDITOR=vim
else
  export EDITOR=vi
fi

# PAGER
export PAGER=/usr/local/bin/vimpager
export MANPAGER=/usr/local/bin/vimpager

# DEVELOP ENV.
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export PATH="$HOME/.ndenv/bin:$PATH"
eval "$(ndenv init -)"

export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
    export PATH=${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:$PATH
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

