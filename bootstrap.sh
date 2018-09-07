#!/bin/bash
set -e

if [ -n "${DEBUG}" ]; then
	set -x
fi

# This script is intended for bootstrapping a new Mac development machine
# with useful tools for developing.

OS=$(uname)
VUNDLE_DIR=${HOME}/.vim/bundle/Vundle.vim

# Only install homebrew if we are on MacOS (Darwin)
if [ "${OS}" == "Darwin" ]; then
	if ! [ -x  $(command -v brew) ]; then
		echo "Installing Homebrew"
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	# Override the default system vim with brew vim
	echo "Installing updated Vim"
	brew install vim --with-override-system-vi
fi

if [ ! -d "${VUNDLE_DIR}" ] ; then
	# Only clone if vundle does not already exist
	# TODO: If installed consider maybe doing a git pull
	git clone https://github.com/VundleVim/Vundle.vim.git ${VUNDLE_DIR}
fi

if [ ! -d "dotfiles" ] ; then
	git clone https://github.com/JonathonGore/dotfiles.git
fi

# TODO: Issue a command for the user to accept or deny overwriting of dotfiles
echo "updating dotfiles in ~/"
mv dotfiles/.profile ~/.profile
mv dotfiles/.vimrc ~/.vimrc
mv dotfiles/.gitconfig ~/.gitconfig
yes | rm -r dotfiles

# Install all plugins defined in ~/.vimrc
vim +PluginInstall +qall

# TODO: Install go

# Once plugins are install we need to specifically compile YouCompleteMe.
# This only installs autocomplate for go - `--all` is also available but it 
# requires all binaries (rust, c++) to be present in the toolchain in PATH.
if [ -x "$(command -v go)" ]; then
	echo 'Go installation detected; installing go completer'
	~/.vim/bundle/YouCompleteMe/install.py --go-completer
fi

~/.vim/bundle/YouCompleteMe/install.py --clang-completer
