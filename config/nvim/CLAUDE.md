# Neovim Configuration

Neovim 0.11.3 config. All Lua, using Lazy.nvim as the plugin manager.

## Structure

```
lua/ducktordanny/
├── core/
│   ├── globals.lua          # Global utilities (P() debug helper)
│   ├── remaps.lua           # Core keymappings
│   └── settings.lua         # Vim options
├── config/
│   └── lazy.lua             # Lazy.nvim bootstrap + plugin loading
├── custom/
│   └── init.lua             # Custom module init (currently empty)
└── plugins/
    ├── *.lua                # Plugin specs (one file per plugin or group)
    └── custom/              # Detailed plugin configs
        ├── cmp.lua
        ├── conform.lua
        ├── fugitive.lua
        ├── gitsigns.lua
        ├── harpoon.lua
        ├── lsp.lua
        ├── lsp-attach-remaps.lua
        ├── lsp-servers.lua
        ├── telescope.lua
        ├── telescope-multigrep.lua
        └── trouble.lua
snippets/                    # LuaSnip snippet files (html, js, ts, json)
```

## Key Decisions

- **Leader:** `<Space>`, **LocalLeader:** `\`
- **Theme:** Rose Pine moon variant with transparent background
- **TypeScript LSP:** `typescript-tools.nvim` (not built-in tsserver) — separate diagnostic server, 12GB max memory, inlay hints on
- **Formatter:** Conform + Prettier (format on save). Prettier for web, Stylua for Lua, gofmt for Go, black+isort for Python
- **File navigation:** Harpoon v2 (5 slots) + Oil for browsing, Neo-tree as tree explorer
- **Git worktrees:** Used via tmux (separate nvim instance per worktree). Custom switcher was removed.

## LSP Servers

Managed via Mason: `lua_ls`, `angularls`, `cssls`, `eslint`, `jsonls`, `gopls`, `typos_lsp`
TypeScript/JS handled separately by `typescript-tools.nvim`.

## Important Keymaps

### Navigation
| Key | Action |
|-----|--------|
| `<leader>sf` | Telescope find files |
| `<leader>sg` | Multi-grep (double `<space>` to filter by filename) |
| `<leader>ss` | Search current dir |
| `<leader><space>` | Find open buffers |
| `<leader>so` | Old files |
| `-` | Open Oil file browser |
| `<leader>h` | Harpoon menu |
| `<leader>hh` | Add file to Harpoon |
| `<leader>n/m/,/./;` | Harpoon slots 1–5 |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references (Telescope) |
| `gI` | Go to implementation |
| `K` | Hover doc |
| `KK` | Signature help |
| `<leader>rn` | Rename |
| `<leader>ca` | Code action |
| `<leader>ri` | Remove unused imports (TS) |
| `:Format` | Format buffer |

### Git
| Key | Action |
|-----|--------|
| `<leader>gg` | Fugitive status |
| `<leader>gc` | Git commit |
| `<leader>gp` | Push (force-with-lease) |
| `<leader>gd` | Diff split |
| `<leader>gl` | Git log (Flog) |
| `<leader>gb` | Git blame |
| `<leader>gu` | Undo hunk |

### Editing
| Key | Action |
|-----|--------|
| `<leader>ff` | Format file/selection |
| `<leader>u` | Toggle Undotree |
| `<leader>d` | Delete to black hole |
| `<leader>y`/`<leader>Y` | Yank to system clipboard |
| `<leader>r` | Replace word under cursor |
| `<leader>ti` | Trouble diagnostics |
| `<leader>tl` | Trouble LSP definitions |

### Window/Splits
| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate panes (Tmux-aware) |
| `<A-h/l>` | Resize width ±5 |
| `<A-j/k>` | Resize height ±5 |
| `<A-u>` | Equalize splits |
| `<leader>t` | New tab (cwd) |
| `<leader>tt` | New tab (current buffer) |

## Editor Settings

- Tab: 2 spaces, expandtab
- `colorcolumn`: 120
- Relative + absolute line numbers (toggle: `<leader>rj`)
- Undofile on (stored in `~/.vim/undodir/`)
- Ripgrep as grep program
- Scroll padding: 8 lines
- Mouse enabled (all modes)

## Conventions

- All plugin specs live in `lua/ducktordanny/plugins/`. One file per plugin (or tightly related group).
- Keymaps for a plugin go in `lua/ducktordanny/plugins/custom/<plugin>.lua`, not inline in the spec.
- Use `P()` (`vim.inspect` wrapper) for debug printing.
- Snippets are JSON files in `snippets/` loaded by LuaSnip.
