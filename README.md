# Neovim Dev Environment Setup

Reproducible instructions for setting up a Neovim environment with autocomplete,
tree view, and agent CLI integration — replacing VSCode/Cursor.

## Prerequisites

- Linux (tested on Ubuntu 20.04+)
- `curl`, `git` installed
- Node.js >= 16 (via nvm)
- Python 3.8+

## Quick Setup (run the script)

```bash
cd ~/dev/neovim-setup
chmod +x install.sh
./install.sh
```

Then reload your shell:
```bash
source ~/.bashrc
```

## What Gets Installed

### Neovim v0.10.3
Downloaded as a prebuilt tarball to `~/.local/opt/nvim-linux64/`, symlinked to `~/.local/bin/nvim`.

### Plugin Manager
**vim-plug** — installed to `~/.local/share/nvim/site/autoload/plug.vim`

### 20 Plugins (via vim-plug)

| Plugin | Purpose |
|--------|---------|
| nerdtree | File tree sidebar |
| nerdtree-git-plugin | Git status in tree |
| vim-devicons | File icons |
| coc.nvim | Autocomplete / LSP engine |
| fzf + fzf.vim | Fuzzy file finder |
| vim-airline + themes | Status bar |
| vim-fugitive | Git commands |
| vim-gitgutter | Git diff in gutter |
| vim-commentary | Toggle comments |
| vim-surround | Change surroundings |
| auto-pairs | Auto-close brackets |
| indent-blankline.nvim | Indent guides |
| nvim-treesitter | Syntax highlighting |
| vim-polyglot | Language pack |
| catppuccin | Color scheme (active) |
| tokyonight.nvim | Color scheme (alt) |
| toggleterm.nvim | Terminal integration |
| copilot.vim | AI completion |

### 9 CoC Language Extensions
coc-json, coc-tsserver, coc-pyright, coc-html, coc-css, coc-yaml, coc-sh, coc-snippets, coc-pairs

### Shell Integration
Aliases added to `~/.bashrc`: `vim`, `vi`, `v` -> `nvim`, plus `vf`, `vd`, `va` helpers.

## Config Files

| File | Purpose |
|------|---------|
| `~/.config/nvim/init.vim` | Main Neovim config |
| `~/.config/nvim/coc-settings.json` | Autocomplete settings |
| `~/.config/nvim/lua/toggleterm-config.lua` | Terminal config |
| `~/.config/nvim/lua/treesitter-config.lua` | Syntax highlighting config |
| `~/.config/nvim/cheatsheet.md` | Keybinding reference |

## Manual Step-by-Step (if not using the script)

See `install.sh` — each step is commented.
