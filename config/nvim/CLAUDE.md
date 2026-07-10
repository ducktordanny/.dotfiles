# Neovim Configuration

Neovim 0.11+ config. All Lua, using Lazy.nvim as the plugin manager.

## Structure

```
init.lua                            # Bootstrap: leaders -> core -> lazy
lua/ducktordanny/
├── options.lua                     # vim.opt
├── keymaps.lua                     # Global keymaps (non-plugin)
├── autocmds.lua                    # Global autocmds (yank hl, relnum, angular ft, trim)
├── css_nav.lua                     # Angular html ↔ scss class navigation (gdc + gr)
├── lazy.lua                        # Lazy.nvim bootstrap + setup
└── plugins/
    ├── colorscheme.lua             # rose-pine + transparent + indent-blankline
    ├── completion.lua              # nvim-cmp + LuaSnip + lazydev + friendly-snippets
    ├── editor.lua                  # surround, autopairs, closetag, illuminate, swap
    ├── format.lua                  # conform.nvim
    ├── git.lua                     # fugitive (+ custom commit helpers), flog, gitsigns
    ├── lsp.lua                     # mason, mason-lspconfig, nvim-lspconfig, fidget, attach handler
    ├── misc.lua                    # jest.nvim
    ├── navigation.lua              # oil, neo-tree, harpoon, tmux-navigator, undotree, lsp-file-operations
    ├── telescope.lua               # telescope + fzf + ui-select + multigrep helper
    ├── treesitter.lua              # treesitter + textobjects + context
    ├── typescript.lua              # typescript-tools + ts-error-translator
    └── ui.lua                      # lualine, trouble, render-markdown, which-key
snippets/                           # LuaSnip snippet files (html, js, ts, json)
```

## Key Decisions

- **Leader:** `<Space>`, **LocalLeader:** `\`
- **Theme:** Rose Pine moon variant with transparent background
- **TypeScript LSP:** `typescript-tools.nvim` (not built-in tsserver) — 12GB max memory, inlay hints off by default (toggle with `<leader>th`), diagnostics on `insert_leave`
- **Formatter:** Conform + Prettier (format after save, async). Prettier for web, Stylua for Lua, gofmt for Go, black+isort for Python
- **File navigation:** Harpoon v2 (5 slots) + Oil for browsing, Neo-tree as tree explorer
- **Git worktrees:** Used via tmux (separate nvim instance per worktree)
- **Completion:** nvim-cmp + LuaSnip + cmp-nvim-lsp/buffer/path, ghost text on

## LSP Architecture

LSP config lives entirely in `plugins/lsp.lua` and uses the Neovim 0.11 `vim.lsp.config` / `vim.lsp.enable` API.

**Critical flow (order matters):**
1. `vim.diagnostic.config` (diagnostics UI) + capabilities from `cmp-nvim-lsp`
2. For each configured server: `vim.lsp.config(name, defaults + per-server opts)`
3. `require("mason").setup()`
4. `require("mason-lspconfig").setup { ensure_installed = <list>, automatic_enable = false }`
5. `vim.lsp.enable(<explicit list>)`

**Why `automatic_enable = false`:** mason-lspconfig 2.x's `automatic_enable` enables **every** installed Mason tool that looks LSP-capable, including `stylua --lsp` (a formatter) and any stale `tailwindcss-language-server` package. That produced random phantom attaches ("Random LSP fixed, dunno..."). We disable it and enable exactly the servers we configured.

**Servers managed via Mason:** `lua_ls`, `angularls`, `cssls`, `eslint`, `jsonls`, `gopls`, `typos_lsp`, `stylelint_lsp`.
TypeScript/JS is handled separately by `typescript-tools.nvim`.

**LspAttach handler:** single autocmd in `plugins/lsp.lua`. Registers buffer-local keymaps, sets up document highlight on CursorHold, and per-client extras (`eslint` auto-fix on save, `angularls` `gdc` CSS jumper). Inlay hints are off by default; `<leader>th` toggles them per-buffer.

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

### LSP (set in the attach handler)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references (Telescope) |
| `gI` | Go to implementation |
| `K` | Hover doc |
| `KK` | Signature help |
| `<leader>rn` | Rename (with `vim.ui.input` prompt) |
| `<leader>ca` | Code action |
| `<leader>ri` | TSTools remove unused imports |
| `<leader>rA` | TSTools add missing imports |
| `<leader>rO` | TSTools organize imports |
| `<leader>th` | Toggle inlay hints |
| `:Format` | Format buffer |
| `<leader>lr` | LspRestart |
| `<leader>lR` | TSTools restart server |

### Git
| Key | Action |
|-----|--------|
| `<leader>gg` | Fugitive status |
| `<leader>gc` | Git commit |
| `<leader>gca` | Git commit amend |
| `<leader>gce` | Git commit amend no-edit |
| `<leader>gp` | Push (force-with-lease) |
| `<leader>gd` | Diff split |
| `<leader>gl` | Git log (Flog) |
| `<leader>gb` | Git blame |
| `<leader>gu` | Undo hunk |
| `[h` / `]h` | Prev/next hunk |
| `ga` (visual) | Stage hunk |

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

- Tab: 2 spaces, expandtab, smartindent
- `colorcolumn`: 120
- Relative + absolute line numbers (toggle: `<leader>rj`)
- Undofile on (stored in `~/.vim/undodir/`)
- Ripgrep as `:grep` program (with `--smart-case`)
- Scroll padding: 8 lines
- Mouse enabled (all modes)
- `laststatus=3` (global statusline)
- `winborder=rounded`

## Conventions

- Global options/keymaps/autocmds live in `lua/ducktordanny/{options,keymaps,autocmds}.lua`.
- Plugin specs live in `lua/ducktordanny/plugins/`. One file per "concern", not one file per plugin — grouped semantically (e.g. all git plugins in `git.lua`).
- Plugin configuration is colocated with the spec (in-spec `opts` or `config` function). No `plugins/custom/` split.
- Lazy loading: prefer `event`, `ft`, `cmd`, or `keys` triggers. Colorscheme and oil/neo-tree are eager (`lazy = false`).
- Use `P()` (`vim.inspect` wrapper) for debug printing.
- Snippets are JSON files in `snippets/` loaded by LuaSnip.

## Deployment

This config is in the dotfiles repo at `~/.config/.dotfiles/config/nvim/`. It is deployed to `~/.config/nvim/` via `~/.config/.dotfiles/setup/apply-config.sh` (run with `:ApplyDotfilesConfigs` from inside Neovim). The deploy script does `rm -rf ~/.config/nvim/*` then `cp -r`, so edits made directly to `~/.config/nvim/` will be lost on next apply.
