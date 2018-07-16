#!/usr/bin/env bash
set -euo pipefail

function exists() {
  type "$1" &> /dev/null ;
}

# Homebrew
if ! exists brew; then
  echo "installing brew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "brew is already installed."
fi

# zsh
if ! brew list | grep zsh &> /dev/null; then
  echo "installing zsh..."
  brew install zsh zsh-completions
  sudo sh -c 'echo $(brew --prefix)/bin/zsh >> /etc/shells'
  chsh -s $(brew --prefix)/bin/zsh
else
  echo "zsh is already installed."
fi

# brew packages
if [ -f "./brew.sh" ]; then
  source ./brew.sh
fi
for package in ${packages[@]}; do
  if ! brew list | grep $package &> /dev/null; then
    echo "installing ${package}..."
    brew install ${package}
  else
    echo "${package} is already installed"
  fi
done

echo "homebrew, zsh, and other packages installed."
