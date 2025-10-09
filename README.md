# OMA Clipboard Manager

A beautiful and efficient clipboard manager for Hyprland with image preview support using kitty, fzf, and cliphist.

<img height="300" alt="image" src="https://github.com/user-attachments/assets/8a9eec2c-c7cb-462d-98eb-e8c1d1d00c94" />
<img height="300" alt="image" src="https://github.com/user-attachments/assets/c9830ee4-c1b8-4a95-89aa-33073bc32041" />


## ✨ Features

- 📋 **Clipboard History**: Keep track of all your copied text and images
- 🖼️ **Image Preview**: View images directly in the terminal using kitty's icat
- 🎨 **Syntax Highlighting**: Text preview with syntax highlighting via bat
- ⚡ **Fast & Fuzzy Search**: Quickly find what you need with fzf
- ⌨️ **Easy Access**: Simple keybinding (ALT+V) to access your clipboard history
- 🪟 **Floating Window**: Clean, minimal floating interface

## 📦 Dependencies

This clipboard manager requires the following tools:

- `kitty` - Terminal emulator with image support
- `fzf` - Fuzzy finder for quick searching
- `cliphist` - Clipboard history manager for Wayland
- `wl-clipboard` - Wayland clipboard utilities
- `wtype` - Wayland keyboard input emulator
- `bat` - Syntax highlighting for text preview
- `imagemagick` - Image manipulation (for the convert command)

## 🚀 Installation

### Automatic Installation (Recommended)

1. Clone this repository:
```bash
git clone https://github.com/YuriRCosta/oma-clipmanager.git
cd oma-clipmanager
```

2. Run the installation script:
```bash
chmod +x install.sh
./install.sh
```

The script will:
- Install `yay` (AUR helper) if not present
- Install all required dependencies
- Copy the script to `~/.config/omarchy/bin/`
- Configure Hyprland bindings and window rules (if files exist)

### Manual Installation

1. Install dependencies:
```bash
yay -S kitty fzf cliphist wl-clipboard wtype bat imagemagick
```

2. Copy the script:
```bash
mkdir -p ~/.config/omarchy/bin
cp fzf-cliphist-preview.sh ~/.config/omarchy/bin/
chmod +x ~/.config/omarchy/bin/fzf-cliphist-preview.sh
```

4. Add window rules to your Hyprland config (`~/.config/hypr/windows.conf` or `hyprland.conf`):
```conf
windowrulev2 = size 20% 45%,class:(fzf-clip)
windowrulev2 = float,class:(fzf-clip)
```

5. Enable clipboard history monitoring (add to `~/.config/hypr/autostart.conf` or your Hyprland config):
```conf
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store
```

6. Reload Hyprland:
```bash
hyprctl reload
```

## 🎯 Usage

1. Copy some text or images to your clipboard
2. Press `ALT+V` to open the clipboard manager
3. Use fuzzy search to find what you need
4. Press `Enter` to paste the selected item

### Preview Features

- **Text**: Displays with syntax highlighting and line numbers
- **Images**: Renders directly in the terminal preview window
- **Code**: Automatically detects and highlights programming languages

## ⚙️ Configuration

### Custom Keybinding

You can change the keybinding by modifying the `bind` line in your Hyprland config:

```conf
bind = ALT, V, exec, sh -c '...'  # Change ALT, V to your preferred keys
```

### Window Size

Adjust the clipboard manager window size:

```conf
windowrulev2 = size 20% 45%,class:(fzf-clip)  # Modify width% height%
```

### Font Size

```conf
kitty --class fzf-clip -o font_size=10  # Change font_size value
```

## 🔧 Troubleshooting

### Images not displaying
- Ensure you're using kitty terminal
- Check if imagemagick is installed: `convert --version`
- Verify kitty's icat works: `kitty +kitten icat /path/to/image.png`

### Clipboard history not working
- Make sure cliphist is running: `ps aux | grep cliphist`
- Verify wl-paste is monitoring clipboard:
  ```bash
  exec-once = wl-paste --type text --watch cliphist store
  exec-once = wl-paste --type image --watch cliphist store
  ```

### Keybinding not working
- Reload Hyprland: `hyprctl reload`
- Check if binding is registered: `hyprctl binds | grep -i clip`

## 📝 License

MIT License - feel free to use and modify as needed!

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests

## 💡 Credits

Created for the Hyprland community. Special thanks to:
- [cliphist](https://github.com/sentriz/cliphist) - Clipboard history manager
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder
- [kitty](https://sw.kovidgoyal.net/kitty/) - Terminal emulator
- [bat](https://github.com/sharkdp/bat) - Syntax highlighter

---

**Note**: This tool is designed specifically for Wayland/Hyprland. It may not work on X11 or other window managers without modifications.
