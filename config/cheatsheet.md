# Neovim Cheatsheet — VSCode/Cursor Keybinding Reference

Leader key = **Space**

## File Explorer (NERDTree)
| Key | Action |
|-----|--------|
| `Ctrl+b` | Toggle file tree (like VSCode sidebar) |
| `Space e` | Toggle file tree |
| `Space f` | Reveal current file in tree |
| `o` / `Enter` | Open file (in tree) |
| `s` | Open in vertical split |
| `i` | Open in horizontal split |
| `m` | Show file menu (create/delete/rename) |

## Autocomplete (CoC)
| Key | Action |
|-----|--------|
| `Tab` | Navigate completion / trigger completion |
| `Shift+Tab` | Previous completion item |
| `Enter` | Accept completion |
| `Ctrl+Space` | Force trigger completion |
| `gd` | Go to definition (F12) |
| `gr` | Find references |
| `gi` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Show hover docs |
| `Space rn` | Rename symbol (F2) |
| `Space ca` | Code actions (Ctrl+.) |
| `Space cf` | Quick fix |
| `[d` / `]d` | Previous/Next diagnostic |
| `Space fm` | Format file |
| `Space oi` | Organize imports |

## Fuzzy Finder (FZF)
| Key | Action |
|-----|--------|
| `Ctrl+p` | Find files (like Ctrl+P in VSCode) |
| `Space ff` | Find files |
| `Space fg` | Grep/search in files (like Ctrl+Shift+F) |
| `Space fb` | Switch buffers |
| `Space fl` | Search in current file lines |
| `Space fc` | Browse git commits |

## Terminal / Agent CLI
| Key | Action |
|-----|--------|
| `Ctrl+\` | Toggle bottom terminal (like Ctrl+` in VSCode) |
| `Space tt` | Horizontal terminal |
| `Space tv` | Vertical terminal |
| `Space tf` | Floating terminal |
| `Space ai` | Large floating terminal (for agent CLI) |
| `Esc` | Exit terminal mode (back to normal mode) |

## Buffers (like VSCode tabs)
| Key | Action |
|-----|--------|
| `Tab` | Next buffer |
| `Shift+Tab` | Previous buffer |
| `Space bd` | Close buffer |

## Editing
| Key | Action |
|-----|--------|
| `gcc` | Toggle comment line |
| `gc` (visual) | Toggle comment selection |
| `Alt+j/k` | Move line down/up |
| `Space d` | Duplicate line |
| `cs'"` | Change surrounding `'` to `"` |
| `Ctrl+s` | Save file |
| `Space q` | Quit |

## Git
| Key | Action |
|-----|--------|
| `:Git` / `:G` | Git status (fugitive) |
| `:Git blame` | Git blame |
| `]c` / `[c` | Next/prev git hunk |

## Window Management
| Key | Action |
|-----|--------|
| `Ctrl+h/j/k/l` | Navigate between panes |
| `:vsp` | Vertical split |
| `:sp` | Horizontal split |

## Shell Aliases
| Alias | Action |
|-------|--------|
| `vim` / `vi` / `v` | Opens Neovim |
| `vf` | Fuzzy find file and open in Neovim |
| `vd` | Open current directory in Neovim |
| `va` | Open Neovim with floating agent terminal |
