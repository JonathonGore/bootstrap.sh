#!/bin/bash
set -e

# This script is intended for bootstrapping a new Mac development machine
# with useful tools for developing.

if  [[ !  -z  $(command -v brew) ]]; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Override the default system vim with brew vim
brew install vim --with-override-system-vi

# Set up vim package manager Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# clone dotfiles from github
git clone https://github.com/JonathonGore/dotfiles.git
mv dotfiles/* ~/
rm -r dotfiles

# Install all plugins defined in ~/.vimrc
vim +PluginInstall +qall

# TODO: Install go

# Once plugins are install we need to specifically compile YouCompleteMe.
# This only installs autocomplate for go - `--all` is also available but it 
# requires all binaries (rust, c++) to be present in the toolchain in PATH.
~/.vim/bundle/YouCompleteMe/install.py --go-completer
