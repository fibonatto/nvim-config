# Neovim Configuration

A modern, feature-rich Neovim configuration written in Lua. This setup provides a highly customizable development environment with support for multiple programming languages, including C/C++, TypeScript, Python, Go, Rust, Lean, and Agda.

## Features

- **Plugin Management**: [Lazy.nvim](https://github.com/folke/lazy.nvim) for lightning-fast plugin loading
- **Theme**: One Half Matte color scheme (light and dark variants) with transparent background support
- **Fuzzy Finding**: [fzf-lua](https://github.com/ibhagwan/fzf-lua) for blazing-fast file and content search
- **Code Execution**: Built-in code runner with terminal output management
- **File Explorer**: Neo-tree for modern file navigation
- **Language Support**: 
  - LSP support for C/C++ (clangd), TypeScript (ts_ls), and more
  - Tree-sitter for advanced syntax highlighting
  - Format-on-save with conform.nvim
- **Git Integration**: Fugitive and Gitsigns for Git workflow
- **Completion**: Blink.cmp for fast, intelligent code completion
- **Debugging**: Built-in diagnostics with custom symbols
- **Custom Features**: 
  - Code screenshot capture with Silicon
  - Time tracking with WakaTime
  - Smart block navigation
  - Quick build system integration

## Directory Structure

```
nvim-config/
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── options.lua      # Editor options, UI, performance settings
│   │   ├── keymaps.lua      # All keybindings (200+ lines)
│   │   ├── plugins.lua      # Plugin definitions and configurations
│   │   └── autocmds.lua     # Auto commands for filetypes and LSP
│   └── onehalfmatte/
│       ├── palette.lua      # Color definitions for light/dark themes
│       ├── highlights.lua   # Syntax highlight definitions
│       └── util.lua         # Theme utility functions
└── colors/
    ├── atomonedark_matte.lua     # Dark theme colorscheme
    └── atomonelight_matte.lua    # Light theme colorscheme
```

## Key Configurations

### Editor Options (`lua/config/options.lua`)

- **Indentation**: Tab-based by default (spaces for JS/TS)
- **Performance**: Optimized redraw and update times
- **Search**: Smart case-sensitive search with ripgrep integration
- **UI**: Line numbers, relative numbering off, 90-char column guide
- **Undo**: Persistent undo files in `~/.local/share/nvim/undo`

### Keybindings (`lua/config/keymaps.lua`)

**Leader Key**: `,` (comma)

#### Window Navigation
- `Ctrl-h/j/k/l` - Navigate between splits
- `Arrow Keys` - Resize windows

#### File & Project
- `Ctrl-p` - Open file finder (fzf-lua)
- `,b` - Switch buffers
- `,rg` - Live grep search
- `Ctrl-a` - Toggle file tree (Neo-tree)

#### Editing
- `!` / `,/` / `,c` - Toggle comment
- `<` / `>` - Indent with visual reselection
- `Shift-j/k` - Jump to next/prev code block
- `Shift-h/l` - WORD motions
- `(` / `)` - Decrease/increase indent

#### LSP
- `gd` - Go to definition
- `gr` - Find references
- `gi` - Go to implementation
- `,lh` - Show hover info
- `,rn` - Rename symbol
- `,ca` - Code action
- `,fm` - Format document
- `[d` / `]d` - Previous/next diagnostic

#### Build System
- `F5` - Run make
- `F6` - Open quickfix list
- `F7` - Next quickfix item
- `F10` - Previous quickfix item
- `F8` - Toggle Aerial (code outline)
- `F9` - Run `./main` binary

#### Git
- `,gs` - Git status
- `,gc` - Git commits

#### Other
- `P` / `,p` - Screenshot with Silicon
- `,w` - Save
- `,q` - Quit
- `ESC` - Exit terminal mode

### Plugins

**Core Plugins:**
- `lazy.nvim` - Plugin manager
- `nvim-treesitter` - Syntax highlighting
- `nvim-lspconfig` - Language server configuration
- `blink.cmp` - Code completion
- `fzf-lua` - Fuzzy finder
- `neo-tree.nvim` - File explorer

**UI/Theme:**
- `One-Half-Matte` - Custom theme
- `transparent.nvim` - Transparent background
- `lualine.nvim` - Status line
- `mini.indentscope` - Indent guides
- `nvim-colorizer.lua` - Color highlighting

**Tools:**
- `conform.nvim` - Code formatting
- `nvim-autopairs` - Auto bracket pairing
- `gitsigns.nvim` - Git signs
- `vim-fugitive` - Git integration
- `vim-silicon` - Code screenshots
- `Comment.nvim` - Comment toggling
- `aerial.nvim` - Code outline

**Language-Specific:**
- `lean.nvim` - Lean 4 support
- `markview.nvim` - Markdown preview
- `vim-asm_ca65` - 65xx Assembly support

### Autocommands (`lua/config/autocmds.lua`)

- **C/C++**: Custom indentation (4-space tabs), color column at 80
- **JavaScript/TypeScript**: 2-space indentation with expanded tabs
- **Agda**: 2-space indentation with expanded tabs
- **LSP**: Attach keymaps when language server connects
- **Auto-reload**: Refresh buffers on focus gain

## Theme System

### Light Theme (Default)
- Clean, high-contrast colors on cream background
- Matte finish, easy on the eyes

### Dark Theme
- Modern dark palette with matte finish
- Optimized for reduced eye strain

**Toggle Theme**:
```vim
:OneHalfMatteToggle
```

Or press `Ctrl-b` and type `OneHalfMatteToggle`.

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/fibonatto/nvim-config ~/.config/nvim
   ```

2. **Start Neovim**:
   ```bash
   nvim
   ```
   
   Lazy.nvim will automatically install all plugins on first run.

3. **Install LSP Servers** (optional but recommended):
   ```bash
   # macOS with Homebrew
   brew install llvm typescript-language-server
   
   # or use your system's package manager
   ```

4. **Install formatters** (optional):
   ```bash
   npm install -g prettier
   pip install ruff
   ```

## Language-Specific Setup

### C/C++
- Uses `clangd` from LLVM toolchain
- Respects `build.sh` if present, otherwise uses `make`
- Format on save with clang-format
- Lint with clang-tidy

### TypeScript/JavaScript
- Uses `ts_ls` language server
- Format on save with Prettier
- 2-space indentation

### Python
- Format with ruff
- LSP support via clangd (configure for Python separately if needed)

### Lean 4
- Full Lean support via `lean.nvim`
- Custom key mappings disabled for flexibility

### Agda
- Agda filetype detection
- 2-space indentation

## Custom Commands

### OneHalfMatteToggle
Toggle between light and dark theme variants.

```vim
:OneHalfMatteToggle
```

## Performance Tuning

The configuration is optimized for speed:
- Treesitter disabled for files > 1MB
- Lazy loading of plugins
- Efficient search with ripgrep
- Custom update/redraw timing

## Dependencies

### Required
- Neovim 0.10+
- git (for plugin installation)

### Optional but Recommended
- **ripgrep** - Fast file searching
- **fzf** - Fuzzy finder binary
- **git** - Version control integration
- **LLVM/clangd** - C/C++ support
- **Node.js** - TypeScript/JavaScript support
- **Python** - Python support

### Optional Tools
- **Prettier** - JavaScript/JSON formatting
- **stylua** - Lua formatting
- **ruff** - Python formatting
- **gofmt** - Go formatting
- **rustfmt** - Rust formatting

## Troubleshooting

### Plugins not installing
Delete the plugin cache and restart:
```bash
rm -rf ~/.local/share/nvim/lazy
```

### LSP not working
Check if the language server is installed:
```vim
:LspInfo
```

### Theme colors look wrong
Make sure your terminal supports 24-bit true color:
```vim
:set termguicolors
```

### Performance issues
Check which plugins are slowing down startup:
```vim
:Lazy profile
```

## Customization

Each configuration section is clearly marked and can be modified:

- **Editor behavior**: `lua/config/options.lua`
- **Keybindings**: `lua/config/keymaps.lua`
- **Plugins**: `lua/config/plugins.lua`
- **Auto commands**: `lua/config/autocmds.lua`
- **Colors**: `lua/onehalfmatte/`

## Credits

- Theme: [One Half Matte](https://github.com/SergioBonatto/One-Half-Matte)
- Plugin manager: [Lazy.nvim](https://github.com/folke/lazy.nvim)
- Additional plugins: See `lua/config/plugins.lua` for full credits

## License

This configuration is provided as-is for personal use. Refer to individual plugin licenses for their terms.
