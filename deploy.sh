#!/usr/bin/env bash
set -euo pipefail

for ${file} in .??*;  do
  [[ "${file}" == ".git" ]] && continue
  [[ "${file}" == ".DS_Store" ]] && continue

  dest=${HOME}/${file}
  if [ -e ${dest} ]; then
    echo "${dest}: skipped (already exists)"
  else
    ln -s $HOME/dotfiles/$file $dest
    echo "${dest}: created"
  fi
  echo "${file}"
done

echo "Create symLink completed."
