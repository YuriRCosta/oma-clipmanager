#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}  OMA Clipboard Manager Setup  ${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Check if running on Arch Linux
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}Error: This installer is designed for Arch Linux and requires pacman.${NC}"
    exit 1
fi

# Check if yay is installed, if not install it
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}yay (AUR helper) not found. Installing yay...${NC}"
    sudo pacman -S --needed --noconfirm git base-devel
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd -
    echo -e "${GREEN}✓ yay installed successfully${NC}"
else
    echo -e "${GREEN}✓ yay is already installed${NC}"
fi

# Install required dependencies
echo ""
echo -e "${BLUE}Installing dependencies...${NC}"

dependencies=(
    "kitty"           # Terminal emulator
    "fzf"             # Fuzzy finder
    "cliphist"        # Clipboard manager
    "wl-clipboard"    # Wayland clipboard utilities
    "wtype"           # Wayland typing tool
    "bat"             # Better cat with syntax highlighting
    "imagemagick"     # Image manipulation (for convert command)
)

for dep in "${dependencies[@]}"; do
    if yay -Q "$dep" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $dep is already installed"
    else
        echo -e "${YELLOW}→${NC} Installing $dep..."
        yay -S --needed --noconfirm "$dep"
        echo -e "${GREEN}✓${NC} $dep installed"
    fi
done

# Create installation directory
INSTALL_DIR="$HOME/.config/omarchy/bin"
echo ""
echo -e "${BLUE}Creating installation directory...${NC}"
mkdir -p "$INSTALL_DIR"
echo -e "${GREEN}✓ Directory created: $INSTALL_DIR${NC}"

# Install the script
echo ""
echo -e "${BLUE}Installing fzf-cliphist-preview.sh...${NC}"
cp fzf-cliphist-preview.sh "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/fzf-cliphist-preview.sh"
echo -e "${GREEN}✓ Script installed to $INSTALL_DIR/fzf-cliphist-preview.sh${NC}"

# Configure Hyprland bindings
echo ""
echo -e "${BLUE}Configuring Hyprland...${NC}"

BINDING_CONTENT='bindd = ALT, V, Clipboard Manager, exec, uwsm app -- kitty --class fzf-clip -o font_size=10 -e sh -c "cliphist list | fzf -d $'\''\t'\'' \
    --with-nth 2 \
    --preview-window=top:50% \
    --preview '\''~/.config/omarchy/bin/fzf-cliphist-preview.sh {}'\'' \
    --bind '\''enter:execute(cliphist decode {1} | wl-copy && wtype -M ctrl -M shift -k v -m ctrl -m shift)+abort'\'' \
    --bind '\''del:execute(cliphist delete <<< {1})+reload(cliphist list)'\'' \
    --bind '\''ctrl-w:execute(cliphist wipe)+reload(cliphist list)'\''"'


WINDOW_RULES='windowrulev2 = size 20% 45%,class:(fzf-clip) # set the size of the window as necessary
windowrulev2 = float,class:(fzf-clip) # ensure you have a floating window class set if you want this behavior'

# Check and configure bindings
BINDINGS_FILE="$HOME/.config/hypr/bindings.conf"
if [ -f "$BINDINGS_FILE" ]; then
    if ! grep -q "fzf-clip" "$BINDINGS_FILE"; then
        echo "$BINDING_CONTENT" >> "$BINDINGS_FILE"
        echo -e "${GREEN}✓ Keybinding added to $BINDINGS_FILE${NC}"
    else
        echo -e "${YELLOW}! Keybinding already exists in $BINDINGS_FILE${NC}"
    fi
else
    echo -e "${YELLOW}! File $BINDINGS_FILE not found${NC}"
    echo -e "${YELLOW}! Please add the following binding to your Hyprland config:${NC}"
    echo ""
    echo -e "${BLUE}$BINDING_CONTENT${NC}"
    echo ""
fi

# Check and configure window rules
WINDOWS_FILE="$HOME/.config/hypr/windows.conf"
if [ -f "$WINDOWS_FILE" ]; then
    if ! grep -q "fzf-clip" "$WINDOWS_FILE"; then
        echo "$WINDOW_RULES" >> "$WINDOWS_FILE"
        echo -e "${GREEN}✓ Window rules added to $WINDOWS_FILE${NC}"
    else
        echo -e "${YELLOW}! Window rules already exist in $WINDOWS_FILE${NC}"
    fi
else
    echo -e "${YELLOW}! File $WINDOWS_FILE not found${NC}"
    echo -e "${YELLOW}! Please add the following window rules to your Hyprland config:${NC}"
    echo ""
    echo -e "${BLUE}$WINDOW_RULES${NC}"
    echo ""
fi

# Setup cliphist with wl-paste (autostart)
AUTOSTART_CONTENT='exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store'

AUTOSTART_FILE="$HOME/.config/hypr/autostart.conf"
if [ -f "$AUTOSTART_FILE" ]; then
    if ! grep -q "cliphist store" "$AUTOSTART_FILE"; then
        echo "$AUTOSTART_CONTENT" >> "$AUTOSTART_FILE"
        echo -e "${GREEN}✓ Autostart commands added to $AUTOSTART_FILE${NC}"
    else
        echo -e "${YELLOW}! Clipboard monitoring already configured in $AUTOSTART_FILE${NC}"
    fi
else
    echo -e "${YELLOW}! File $AUTOSTART_FILE not found${NC}"
    echo -e "${YELLOW}! Please add the following to your Hyprland config:${NC}"
    echo ""
    echo -e "${BLUE}$AUTOSTART_CONTENT${NC}"
    echo ""
fi

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}  Installation Complete! 🎉${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo -e "${BLUE}Usage:${NC}"
echo -e "  Press ${GREEN}ALT+V${NC} to open the clipboard manager"
echo ""
echo -e "${YELLOW}Note: You may need to reload your Hyprland configuration for changes to take effect.${NC}"
echo -e "${YELLOW}Run: hyprctl reload${NC}"
echo ""
