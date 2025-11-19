#!/bin/bash

echo "removing old configs"
rm -rf ~/.config/nvim ~/.config/tmux ~/.bash_aliases

stow .config
stow .bash_aliases 
