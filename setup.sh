#!/usr/bin/env bash
source ~/strict.bash

# in fish:
#alias .f='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
#alias .s='git --git-dir=$HOME/.dotfiles-secret/ --work-tree=$HOME'

# run: https://github.com/AndreTheHunter/dotfiles/blob/master/set-dotfiles-repos

./install-omf
./install-fonts
./install-vim-plug
./install-rust
