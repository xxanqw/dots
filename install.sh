#!/bin/bash

# ✨ My Dots - Auto Installation Script

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print functions
print_step() {
    echo -e "\n${BLUE}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Check for yay
if ! command -v yay &> /dev/null; then
    print_step "yay not found, installing it now"
    sudo pacman -S --needed git base-devel --noconfirm || print_error "Failed to install dependencies"
    git clone https://aur.archlinux.org/yay.git || print_error "Failed to clone yay repository"
    cd yay || print_error "Failed to enter yay directory"
    makepkg -si --noconfirm || print_error "Failed to build and install yay"
    cd .. && rm -rf yay
    print_success "yay installed successfully"
fi

# ZSH Setup
print_step "Installing Zsh"
yay -S zsh --noconfirm || print_error "Failed to install Zsh"
print_success "Zsh installed"

print_step "Installing Oh-My-Zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
    print_warning "Oh-My-Zsh already installed"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh-My-Zsh installed"
fi

# Install plugins
print_step "Installing Zsh plugins"

# zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    print_success "zsh-autosuggestions installed"
else
    print_warning "zsh-autosuggestions already installed"
fi

# zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    print_success "zsh-syntax-highlighting installed"
else
    print_warning "zsh-syntax-highlighting already installed"
fi

# fast-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" ]; then
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
    print_success "fast-syntax-highlighting installed"
else
    print_warning "fast-syntax-highlighting already installed"
fi

# Install theme
print_step "Installing Oxide theme"
wget -q https://raw.githubusercontent.com/dikiaap/dotfiles/refs/heads/master/.oh-my-zsh/themes/oxide.zsh-theme -P ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/
print_success "Oxide theme installed"

# Download .zshrc
print_step "Downloading .zshrc configuration"
if [ -f "$HOME/.zshrc" ]; then
    mv $HOME/.zshrc $HOME/.zshrc.backup
    print_warning "Existing .zshrc backed up to .zshrc.backup"
fi
wget -q https://raw.githubusercontent.com/xxanqw/dots/refs/heads/main/.zshrc -P ~/
print_success ".zshrc installed"

# Fastfetch setup
print_step "Installing Fastfetch"
yay -S fastfetch --noconfirm || print_error "Failed to install Fastfetch"
print_success "Fastfetch installed"

print_step "Setting up Fastfetch"
mkdir -p ~/.config/fastfetch
wget -q https://raw.githubusercontent.com/xxanqw/dots/refs/heads/main/.config/fastfetch/config.jsonc -P ~/.config/fastfetch/
wget -q https://raw.githubusercontent.com/xxanqw/dots/refs/heads/main/.config/fastfetch/arch.png -P ~/.config/fastfetch/
print_success "Fastfetch configured"

echo -e "\n${GREEN}✨ Installation complete!${NC}"
echo -e "${BLUE}Run 'chsh -s $(which zsh)' to set Zsh as your default shell${NC}"
echo -e "${BLUE}Then log out and back in, or run 'zsh' to start using your new setup${NC}"
echo -e "\n${GREEN}🎉 Enjoy your freaky setup!${NC}\n"