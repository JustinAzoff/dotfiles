#!/bin/sh
#vim
ln -s ~/projects/dotfiles/vim/vimrc.minimal ~/.vimrc
mkdir -p ~/.vim/autoload ~/.vim/bundle; \
if [ ! -e ~/.vim/autoload/pathogen.vim ]; then
    curl -so ~/.vim/autoload/pathogen.vim \
        https://raw.github.com/tpope/vim-pathogen/HEAD/autoload/pathogen.vim
fi

mkdir -p ~/.vim/_backup  ~/.vim/_temp

#xmonad
mkdir -p ~/.xmonad
ln -s ~/projects/dotfiles/xmonad/xmonad.hs ~/.xmonad

#awesome
mkdir -p ~/.config/awesome/
ln -s ~/projects/dotfiles/awesome/rc.lua ~/.config/awesome/

#xresources
ln -s ~/projects/dotfiles/Xresources ~/.Xresources

dpkg -l xfonts-terminus &> /dev/null || sudo apt-get install xfonts-terminus
dpkg -l rxvt-unicode &> /dev/null || sudo apt-get install rxvt-unicode
