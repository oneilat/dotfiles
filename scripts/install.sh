#!/bin/bash
echo "Setting up your environment..."

# Install necessary packages
sudo dnf install -y git neovim tmux alacritty

# Create symlinks
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.zshenv ~/.zshenv
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/hypr ~/.config/hypr
ln -sf ~/dotfiles/.config/alacritty ~/.config/alacritty
ln -sf ~/dotfiles/.config/starship.toml ~/.config/starship.toml

echo "Done! Restart your terminal to apply changes."
