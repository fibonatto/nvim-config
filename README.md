# Neovim Configuration

A Lua-based Neovim setup focused on a fast, keyboard-first workflow for C/C++, TypeScript, Python, Markdown, and general software development.

## Features

- **Plugin Management**: [Lazy.nvim](https://github.com/folke/lazy.nvim) for fast startup and lazy loading
- **Theme**: [One Half Matte](https://github.com/SergioBonatto/One-Half-Matte) with light/dark variants
- **Fuzzy Finding**: [fzf-lua](https://github.com/ibhagwan/fzf-lua) for files, buffers, grep, and symbols
- **Code Execution**: Built-in project runner with terminal output support via `nvim-run-code`
- **File Explorer**: Neo-tree for project navigation
- **Language Support**:
  - LSP for C/C++ (`clangd`) and TypeScript (`ts_ls`)
  - Treesitter for syntax-aware editing
  - Format-on-save with `conform.nvim`
- **Git Integration**: `vim-fugitive` and `gitsigns.nvim`
- **Completion**: `blink.cmp` for fast inline completion
- **Diagnostics & Outline**: LSP diagnostics and `aerial.nvim`
- **Custom Productivity Features**:
  - Code screenshots with `vim-silicon`
  - Smart block navigation
  - Quick comment toggling
  - Custom theme toggle command

## Directory Structure

```
nvim-config/
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── options.lua      # Editor options, UI, and performance settings
│   │   ├── keymaps.lua      # Keybindings and custom mappings
│   │   ├── plugins.lua      # Plugin definitions and config
│   │   └── autocmds.lua     # Filetype and LSP-related autocmds
│   └── onehalfmatte/
│       ├── palette.lua      # Theme palette
│       ├── highlights.lua   # Highlight groups
│       └── util.lua         # Theme helpers
├── colors/
│   ├── atomonedark_matte.lua
│   └── atomonelight_matte.lua
└── README.md
```

## Key Configurations

### Editor Options (`lua/config/options.lua`)

- **Indentation**: tabs off by default, with 2-space indentation in most filetypes
- **Performance**: tuned redraw/update intervals and `rg`-based grep
- **Search**: smart-case search with ripgrep
- **UI**: line numbers, color column at 90, split options enabled
- **Undo**: persistent undo files in `~/.local/share/nvim/undo`
- **Clipboard**: system clipboard enabled via `unnamedplus`

### Keybindings (`lua/config/keymaps.lua`)

**Leader key**: `,`

#### Window Navigation
- `Ctrl-h/j/k/l` - Move between splits
- Arrow keys - Resize windows

#### File & Project
- `Ctrl-p` - Open file finder (`fzf-lua`)
- `<leader>b` - Switch buffers
- `<leader>rg` - Live grep
- `<leader>ff` - Resume previous fzf session
- `<leader>gs` - Git status
- `<leader>gc` - Git commits
- `<leader>sd` / `<leader>sw` - Document/workspace symbols
- `Ctrl-a` - Toggle Neo-tree

#### Editing
- `!` / `<leader>/` / `<leader>c` - Toggle comments
- `U` - Redo
- `m` - Jump to matching bracket/parenthesis
- `(` / `)` - Decrease/increase indent in normal mode
- `<` / `>` - Re-indent visual selection
- `Shift-j/k` - Jump to next/previous non-empty code block
- `Shift-h/l` - Word motion (`B`/`W` style)

#### Build System
- `F5` - Run `make`
- `F6` - Open quickfix list
- `F7` - Next quickfix item
- `F10` - Previous quickfix item
- `F8` - Toggle Aerial outline
- `F9` - Run `./main`

#### LSP
- `gd` - Go to definition
- `gr` - Find references
- `gi` - Go to implementation
- `<leader>lh` - Hover
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code action
- `<leader>fm` - Format document
- `[d` / `]d` - Previous/next diagnostic

#### Git / Extras
- `P` / `<leader>p` - Screenshot with Silicon (visual mode)
- `<leader>w` - Save
- `<leader>q` - Quit
- `<leader>x` - Save + quit
- `ESC` - Exit terminal mode

### Plugins

**Core**
- `lazy.nvim` - Plugin manager
- `nvim-treesitter` - Syntax highlighting
- `nvim-lspconfig` - Language server configuration
- `blink.cmp` - Completion
- `fzf-lua` - Fuzzy search
- `neo-tree.nvim` - File explorer

**UI / Theme**
- `One-Half-Matte` - Light/dark theme
- `lualine.nvim` - Status line
- `mini.indentscope` - Indent guides
- `nvim-colorizer.lua` - Color preview

**Tools / Productivity**
- `nvim-run-code` - Code execution panel
- `basal-nvim` - Project-aware workflow helper
- `conform.nvim` - Auto-formatting
- `gitsigns.nvim` - Git sign indicators
- `vim-fugitive` - Git integration
- `Comment.nvim` - Comment toggling
- `aerial.nvim` - Symbol outline
- `vim-silicon` - Code screenshots
- `vim-easy-align` - Alignment helper
- `vim-todo-highlight` - TODO highlight
- `cord.nvim` - Presence integration
- `VimFileType` - Extra filetype detection

**Language-Specific**
- `lean.nvim` - Lean 4 support
- `markview.nvim` - Markdown preview
- `bend-vim` - Bend file support
- `vim-asm_ca65` - 65xx assembly support
- `Microchip-Linker-Script-syntax-file` - linker script syntax highlighting

### Autocommands (`lua/config/autocmds.lua`)

- **Auto reload**: refresh on focus and buffer enter
- **C/C++**: 4-space indentation, `makeprg = ./build.sh` when present or `make`
- **JavaScript/TypeScript**: 2-space indentation
- **Agda**: 2-space indentation
- **Custom filetype**: `*.phi` is treated as `phi`
- **LSP keymaps**: automatically attached to LSP buffers

## Theme System

The setup uses the `One-Half-Matte` colorscheme and defaults to the light variant:

- `atomonelight_matte` - default theme
- `atomonedark_matte` - alternate dark theme

### Toggle theme

```vim
:OneHalfMatteToggle
```

This command switches between light and dark variants.

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/fibonatto/nvim-config ~/.config/nvim
   ```

2. **Start Neovim**:
   ```bash
   nvim
   ```

   Lazy.nvim will install the required plugins on the first run.

3. **Install LSP servers** (optional but recommended):
   ```bash
   # macOS with Homebrew
   brew install llvm node typescript-language-server
   ```

4. **Install formatters** (optional):
   ```bash
   npm install -g prettier
   pip install ruff
   ```

## Language-Specific Setup

### C/C++
- Uses `clangd` from the LLVM toolchain
- Uses `./build.sh` if available, otherwise falls back to `make`
- Formatting via `clang_format` with a Linux-style configuration

### TypeScript/JavaScript
- Uses `ts_ls` language server
- Formatting with Prettier on save
- 2-space indentation by default

### Python
- Formatting uses `ruff_format`
- Python LSP can be added separately if needed

### Lean 4
- Full Lean support via `lean.nvim`
- Custom keymaps are disabled for flexibility

### Agda
- Agda filetype detection is enabled
- 2-space indentation

## Custom Commands

### OneHalfMatteToggle

Switches between light and dark variants of the theme.

```vim
:OneHalfMatteToggle
```

## Performance Tuning

This configuration is optimized for responsiveness:
- Treesitter is skipped for files larger than 1 MB
- Plugins are lazily loaded with `lazy.nvim`
- Search uses ripgrep for faster project indexing
- Update/redraw timings are tuned in `options.lua`

## Dependencies

### Required
- Neovim 0.10+
- git

### Optional but Recommended
- **ripgrep** - fast file searching
- **fzf** - terminal fuzzy finder
- **LLVM / clangd** - C/C++ support
- **Node.js** - TypeScript/JavaScript tooling
- **Python** - Python formatting and tooling

### Optional Tools
- **Prettier** - JS/JSON formatting
- **stylua** - Lua formatting
- **ruff** - Python formatting
- **gofmt** - Go formatting
- **rustfmt** - Rust formatting
- **shfmt** - shell formatting

## Troubleshooting

### Plugins not installing
Delete the plugin cache and restart:
```bash
rm -rf ~/.local/share/nvim/lazy
```

### LSP not working
Check which servers are active:
```vim
:LspInfo
```

### Theme colors look wrong
Ensure the terminal supports 24-bit color:
```vim
:set termguicolors
```

### Performance issues
Inspect lazy startup diagnostics:
```vim
:Lazy profile
```

## Customization

Each main configuration area is intentionally separated for easy editing:

- **Editor behavior**: `lua/config/options.lua`
- **Keybindings**: `lua/config/keymaps.lua`
- **Plugin setup**: `lua/config/plugins.lua`
- **Auto commands**: `lua/config/autocmds.lua`
- **Theme**: `lua/onehalfmatte/` and `colors/`

## Credits

- Theme: [One Half Matte](https://github.com/SergioBonatto/One-Half-Matte)
- Plugin manager: [Lazy.nvim](https://github.com/folke/lazy.nvim)
- Additional plugin authors are credited inline in `lua/config/plugins.lua`

## License

This configuration is provided as-is for personal use. Refer to the individual plugin licenses for their terms.
