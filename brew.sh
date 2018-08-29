#!/usr/bin/env bash

packages=(
  bash
  "vim --with-gettext --with-override-system-vi"
  awscli
  tig
  "wget --with-iri"
  "gnu-sed --with-default-names"
  yq
  httpie
  highlight
  go
  pyenv
  pyenv-virtualenv
  docker-machine
  docker-machine-driver-xhyve
  kubernetes-cli
  kubernetes-helm
  redis
  sqlite
  mysql
  mycli
  pgcli
  ctags
)

# 自動インストールはしない
cask_packages=(
  iterm2
  google-chrome
  "firefox --language=ja"
  virtualbox
  wireshark
  burp-suite
  minikube
  evernote
  dropbox
  1password
  postman
  boostnote
  vscode
  sourcetree
  vscode
  gimp
)
