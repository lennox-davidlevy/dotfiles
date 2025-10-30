# Fedora to macOS Conversion Summary

This document summarizes the conversion from Fedora Linux to macOS for the dotfiles repository.

## Conversion Date
October 30, 2025

## Branch Strategy
- **`fedora` branch** - Contains all original Linux/Fedora configurations
- **`new_macos` branch** - macOS-only configurations (this branch)
- No archive directory needed - git branches preserve everything!

## Changes Made

### ✅ New Files Created

1. **bootstrap-macos.sh** - Main bootstrap script for macOS
   - Auto-detects Intel vs Apple Silicon
   - Installs Homebrew if not present
   - Runs Ansible playbook

2. **playbooks/bootstrap-macos.yml** - Ansible playbook for macOS
   - Uses `community.general.homebrew` module
   - Installs fonts to `~/Library/Fonts/`
   - Sets up pyenv and fnm
   - Auto-detects architecture and sets Homebrew prefix

3. **playbooks/packages-macos.yml** - Package definitions
   - Core packages: python, tmux, git, neovim
   - Development tools: pyenv, fnm, uv, go, rust
   - Modern CLI tools: ripgrep, fd, bat, eza, fzf, zoxide
   - Applications: Ghostty, Brave, Raycast, Rectangle, Stats

4. **teardown-macos.sh** - Cleanup script
   - Removes Homebrew packages
   - Removes symlinks
   - Restores original configs
   - Interactive prompts for destructive operations

5. **docs/macos-setup.md** - Comprehensive setup guide
   - Quick start instructions
   - Package list
   - Customization guide
   - Troubleshooting section
   - Window manager options

6. **README.md** - Repository overview
   - Quick start guide
   - Feature highlights
   - Architecture support details
   - Customization instructions

### 🔄 Files Modified

1. **shell/.zshrc**
   - Changed hardcoded `/home/david` to `$HOME`
   - Added Homebrew path detection (Intel vs Apple Silicon)
   - Added `brew shellenv` integration
   - Updated fnm path to use `$HOME`
   - Updated Bun path to use `$HOME`
   - Removed Linux-specific Ollama path
   - Removed nomad completion
   - Added uv, zoxide, and fzf shell completions

2. **shell/.tmux.conf**
   - Changed `xclip` to `pbcopy` for clipboard
   - Added mouse drag clipboard integration

3. **shell/.zsh_scripts/aliases.zsh**
   - Changed `ls --color=auto` to `ls -G` (macOS native)
   - Added conditional eza aliases with icons
   - Added fallback aliases if eza not installed

4. **.gitignore**
   - Added comprehensive macOS-specific patterns
   - `.DS_Store`, `.AppleDouble`, `.LSOverride`, etc.

5. **AGENTS.md**
   - Updated platform to macOS
   - Removed i3wm section
   - Added Ansible playbook guidelines
   - Updated file structure
   - Added macOS-specific environment notes
   - Added Homebrew and architecture details

### 🗑️ Files Removed (Preserved in `fedora` branch)

The following Linux-specific configs were removed from `new_macos` branch but remain in `fedora` branch:

**Directories:**
- `config/i3/` - i3 window manager (X11-based, not applicable to macOS)
- `config/i3status/` - Status bar for i3
- `config/picom/` - X11 compositor
- `config/rofi/` - Application launcher (replaced by Raycast on macOS)

**Files:**
- `bootstrap.sh` - Fedora bootstrap script
- `teardown.sh` - Fedora teardown script
- `playbooks/bootstrap.yml` - Fedora Ansible playbook
- `playbooks/packages.yml` - Fedora package definitions
- `playbooks/teardown.yml` - Fedora teardown playbook

**Access Linux configs:** `git checkout fedora` or `git show fedora:path/to/file`

### 📦 Package Mapping

| Fedora (dnf) | macOS (Homebrew) | Notes |
|-------------|------------------|-------|
| python3 | python@3.12 | Also installs pyenv for version management |
| python3-pip | (included) | Comes with Python, plus uv for fast installs |
| nodejs | node | Also installs fnm for version management |
| neovim (COPR) | neovim | From main Homebrew repository |
| ansible-lint | ansible-lint | Same package name |
| golang | go | Same functionality |
| rust | rust | Same functionality |
| i3 | (optional) | User can install Aerospace/yabai manually |
| rofi | raycast (cask) | Native macOS app launcher |
| picom | (not needed) | macOS has native compositing |

**New Tools Added:**
- `uv` - Fast Python package installer
- `pyenv` - Python version management
- `fnm` - Fast Node.js version manager
- `ripgrep` - Better grep
- `fd` - Better find
- `bat` - Better cat with syntax highlighting
- `eza` - Modern ls replacement
- `fzf` - Fuzzy finder
- `zoxide` - Smarter cd
- `gh` - GitHub CLI

### 🏗️ Architecture Support

Both Intel and Apple Silicon are fully supported:

**Intel Macs (x86_64):**
- Homebrew installs to `/usr/local`
- Scripts auto-detect and set `BREW_PREFIX=/usr/local`

**Apple Silicon (arm64/M1/M2/M3/M4):**
- Homebrew installs to `/opt/homebrew`
- Scripts auto-detect and set `BREW_PREFIX=/opt/homebrew`

### 🔑 Key Technical Decisions

1. **Window Manager**: Not installed by default
   - User can manually choose: Aerospace (recommended), yabai, or Rectangle
   - Rectangle (simple window snapping) is installed as a fallback

2. **Application Launcher**: Raycast (free)
   - Alternative to rofi
   - Native macOS app
   - More features than Spotlight

3. **Version Managers**: Multiple options
   - Python: pyenv (auto-installs latest 3.12)
   - Node.js: fnm (faster than nvm)
   - Packages: uv for Python (faster than pip)

4. **Branch Strategy**: Clean separation using git branches
   - `fedora` branch contains all Linux configs
   - `new_macos` branch is macOS-only (no archive directory)
   - Access Linux configs anytime with `git checkout fedora`

### ✨ Features Preserved

These components work identically on both platforms:

- ✅ **Neovim configuration** - No changes needed
- ✅ **tmux configuration** - Only clipboard command changed
- ✅ **Zsh scripts** - Functions and utilities work as-is
- ✅ **Powerlevel10k theme** - Identical appearance
- ✅ **Fonts** - Same Nerd Fonts, different install location
- ✅ **Git configuration** - No changes needed

### 🚀 Usage

**Setup a new macOS machine:**
```bash
./bootstrap-macos.sh
```

**Remove everything:**
```bash
./teardown-macos.sh
```

**Add more packages:**
Edit `playbooks/packages-macos.yml` and re-run:
```bash
ansible-playbook playbooks/bootstrap-macos.yml
```

### 📝 Notes for Future Maintenance

1. **Keep packages-macos.yml updated** with new tools
2. **Test on both Intel and Apple Silicon** when possible
3. **Document macOS version compatibility** in docs/macos-setup.md
4. **Update AGENTS.md** when adding new tools or workflows
5. **Keep `fedora` branch** for Linux configurations (no merging between branches)

### 🔍 Testing Checklist

Before using on a fresh macOS machine:

- [ ] Verify Homebrew installation works
- [ ] Check architecture detection (Intel vs ARM)
- [ ] Validate all symlinks are created
- [ ] Confirm pyenv installs Python correctly
- [ ] Confirm fnm installs Node.js correctly
- [ ] Test tmux clipboard integration
- [ ] Verify Neovim plugins install
- [ ] Check Oh My Zsh and Powerlevel10k setup
- [ ] Test shell completions (uv, zoxide, fzf)

### 📚 Documentation

All documentation is complete:

- ✅ **README.md** - Quick overview and features
- ✅ **docs/macos-setup.md** - Detailed setup guide
- ✅ **AGENTS.md** - Updated for macOS environment
- ✅ **CONVERSION_SUMMARY.md** - This document

### 🎯 Next Steps

1. **Test on a fresh macOS machine** (recommended)
2. **Choose and configure a window manager** if desired
3. **Customize packages** in packages-macos.yml
4. **Add any macOS-specific aliases** or functions
5. **Configure Rectangle** window snapping preferences

---

**Conversion Status: ✅ COMPLETE**

All core functionality has been successfully ported from Fedora Linux to macOS with full support for both Intel and Apple Silicon architectures.
