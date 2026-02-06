#!/usr/bin/env bash
# =============================================================================
# Neovim Dev Environment Installer
# Reproduces the exact setup: autocomplete, tree view, agent CLI integration
# =============================================================================
set -euo pipefail

NVIM_VERSION="v0.10.3"
NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz"

echo "========================================="
echo " Neovim Dev Environment Setup"
echo "========================================="

# ---------------------------------------------------------------------------
# Step 1: Ensure Node.js >= 16 is available (required by CoC.nvim)
# ---------------------------------------------------------------------------
echo ""
echo "[1/7] Checking Node.js..."
if command -v node &>/dev/null; then
    NODE_MAJOR=$(node -v | sed 's/v//' | cut -d. -f1)
    if [ "$NODE_MAJOR" -lt 16 ]; then
        echo "  ERROR: Node.js >= 16 is required (found $(node -v))."
        echo "  Install via nvm: nvm install --lts"
        exit 1
    fi
    echo "  Found Node.js $(node -v) — OK"
else
    echo "  ERROR: Node.js not found."
    echo "  Install nvm first: https://github.com/nvm-sh/nvm"
    echo "  Then: nvm install --lts"
    exit 1
fi

# ---------------------------------------------------------------------------
# Step 2: Install Neovim
# ---------------------------------------------------------------------------
echo ""
echo "[2/7] Installing Neovim ${NVIM_VERSION}..."
mkdir -p ~/.local/bin ~/.local/opt

if [ -f ~/.local/opt/nvim-linux64/bin/nvim ]; then
    INSTALLED_VERSION=$(~/.local/opt/nvim-linux64/bin/nvim --version | head -1 | awk '{print $2}')
    if [ "$INSTALLED_VERSION" = "$NVIM_VERSION" ]; then
        echo "  Neovim ${NVIM_VERSION} already installed — skipping"
    else
        echo "  Upgrading from ${INSTALLED_VERSION} to ${NVIM_VERSION}..."
        rm -rf ~/.local/opt/nvim-linux64
    fi
fi

if [ ! -f ~/.local/opt/nvim-linux64/bin/nvim ]; then
    TMPFILE=$(mktemp /tmp/nvim-linux64.XXXXXX.tar.gz)
    curl -L "$NVIM_URL" -o "$TMPFILE"
    tar xzf "$TMPFILE" -C ~/.local/opt/
    rm -f "$TMPFILE"
    echo "  Installed to ~/.local/opt/nvim-linux64/"
fi

# Create symlink
ln -sf ~/.local/opt/nvim-linux64/bin/nvim ~/.local/bin/nvim
export PATH="$HOME/.local/bin:$PATH"
echo "  Symlinked to ~/.local/bin/nvim"
echo "  $(nvim --version | head -1)"

# ---------------------------------------------------------------------------
# Step 3: Install vim-plug (plugin manager)
# ---------------------------------------------------------------------------
echo ""
echo "[3/7] Installing vim-plug..."
PLUG_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
if [ -f "$PLUG_PATH" ]; then
    echo "  vim-plug already installed — skipping"
else
    curl -fLo "$PLUG_PATH" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "  Installed vim-plug"
fi

# ---------------------------------------------------------------------------
# Step 4: Write config files
# ---------------------------------------------------------------------------
echo ""
echo "[4/7] Writing Neovim config files..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="$HOME/.config/nvim"

mkdir -p "$NVIM_CONFIG_DIR/lua"

cp "$SCRIPT_DIR/config/init.vim"               "$NVIM_CONFIG_DIR/init.vim"
cp "$SCRIPT_DIR/config/coc-settings.json"       "$NVIM_CONFIG_DIR/coc-settings.json"
cp "$SCRIPT_DIR/config/lua/toggleterm-config.lua" "$NVIM_CONFIG_DIR/lua/toggleterm-config.lua"
cp "$SCRIPT_DIR/config/lua/treesitter-config.lua" "$NVIM_CONFIG_DIR/lua/treesitter-config.lua"
cp "$SCRIPT_DIR/config/cheatsheet.md"           "$NVIM_CONFIG_DIR/cheatsheet.md"

echo "  Wrote ~/.config/nvim/init.vim"
echo "  Wrote ~/.config/nvim/coc-settings.json"
echo "  Wrote ~/.config/nvim/lua/toggleterm-config.lua"
echo "  Wrote ~/.config/nvim/lua/treesitter-config.lua"
echo "  Wrote ~/.config/nvim/cheatsheet.md"

# ---------------------------------------------------------------------------
# Step 5: Install plugins via vim-plug
# ---------------------------------------------------------------------------
echo ""
echo "[5/7] Installing Neovim plugins (this may take a minute)..."
nvim --headless +PlugInstall +qall 2>&1 | tail -5 || true
echo "  Plugins installed"

# ---------------------------------------------------------------------------
# Step 6: Install CoC language extensions
# ---------------------------------------------------------------------------
echo ""
echo "[6/7] Installing CoC language extensions..."
nvim --headless \
    +'CocInstall -sync coc-json coc-tsserver coc-pyright coc-html coc-css coc-yaml coc-sh coc-snippets coc-pairs' \
    +qall 2>&1 | tail -5 || true
echo "  CoC extensions installed:"
ls ~/.config/coc/extensions/node_modules/ 2>/dev/null | sed 's/^/    /'

# ---------------------------------------------------------------------------
# Step 7: Add shell integration to ~/.bashrc
# ---------------------------------------------------------------------------
echo ""
echo "[7/7] Configuring shell..."

BASHRC_MARKER="# --- Neovim Dev Environment ---"

if grep -qF "$BASHRC_MARKER" ~/.bashrc 2>/dev/null; then
    echo "  Shell config already present in ~/.bashrc — skipping"
else
    cat >> ~/.bashrc << 'BASHRC_BLOCK'

# --- Neovim Dev Environment ---
export PATH="$HOME/.local/bin:$PATH"
export VISUAL=nvim
export EDITOR="$VISUAL"
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

# Quick open in Neovim
alias vf='nvim $(fzf)'           # fuzzy find and open file
alias vd='nvim .'                # open current dir in Neovim (triggers NERDTree)

# Agent CLI helper — launch agent in a Neovim floating terminal
alias va='nvim -c "lua _AGENT_TOGGLE()"'
# --- End Neovim Dev Environment ---
BASHRC_BLOCK
    echo "  Added Neovim aliases to ~/.bashrc"
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo ""
echo "========================================="
echo " Setup Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "  1. Reload shell:  source ~/.bashrc"
echo "  2. Open Neovim:   vim  (or v, vi)"
echo "  3. Open project:  v .  (NERDTree opens for directories)"
echo "  4. Agent CLI:     Space+ai inside Neovim, or 'va' from shell"
echo "  5. Cheatsheet:    ~/.config/nvim/cheatsheet.md"
echo ""
