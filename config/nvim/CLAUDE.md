# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build/Test Commands

- **Test config**: `nvim` (auto-loads from `init.lua`; no separate build step)
- **Reload config**: `:source %` in Neovim, or restart Neovim entirely
- **Reload a single plugin**: `:Lazy reload <plugin-name>`
- **Check syntax**: `luacheck lua/` (if luacheck is installed)
- **Format Lua**: `stylua lua/` (2-space indent, 120-col width, double quotes — see `stylua.toml`)
- **Manage plugins**: `:Lazy` (open UI to install/update/clean)
- **Manage LSP servers**: `:Mason` (auto-installs servers on first run)

## Architecture

Entry point is `init.lua`, which:
1. Requires `lua/core/options.lua` and `lua/core/keymaps.lua`
2. Bootstraps lazy.nvim (auto-downloads if missing from `~/.local/share/nvim/lazy/`)
3. Calls `require("lazy").setup("plugins", ...)`, which loads every file in `lua/plugins/` as a plugin spec

**`lua/core/`** — two files only: `options.lua` (vim options) and `keymaps.lua` (window/split/tab bindings). Leader key is `,`.

**`lua/plugins/`** — one file per plugin/feature. Each file returns a lazy.nvim spec table. Keybindings, dependencies, and config for a plugin live in its own file. Lazy loading is triggered via `keys`, `cmd`, or `event` (e.g., `VeryLazy`, `BufReadPre`, `InsertEnter`).

**`snippets/`** — VSCode-format JSON snippets (currently YAML/K8s). Loaded by LuaSnip via `friendly-snippets` integration.

## Key Plugin Relationships

- **LSP**: `lsp-config.lua` uses Mason + mason-lspconfig to auto-install servers. Capabilities are wired from `cmp_nvim_lsp`. LSP keymaps are set in a `LspAttach` autocmd. Uses the newer `vim.lsp.config()` + `vim.lsp.enable()` API (not the old `lspconfig.server.setup()` pattern).
- **Completion**: `completions.lua` — nvim-cmp with LuaSnip. Sources: lsp → luasnip → path → buffer.
- **Formatting**: `conform.lua` — runs formatters per filetype on `<leader>gf`. No auto-format on save.
- **Linting**: `none-ls.lua` — none-ls (null-ls fork) with none-ls-extras. Feeds diagnostics through the LSP protocol, giving version-aware live diagnostics. Sources: ansiblelint, ruff (Python), dotenv-linter.
- **Git**: `gitsigns.lua` (gutter signs, hunks, blame) + `neogit.lua` (Neogit UI, Diffview for diffs).
- **Fuzzy find**: `telescope.lua` — files, grep, buffers, LSP symbols/diagnostics, git status/commits.
- **AI**: `opencode-nvim.lua` — IBM OpenCode integration via tmux terminal (`<leader>c` group).
- **Remote editing**: `remote-sshfs.nvim` — SSH filesystem mounting with Telescope (`<leader>r` group).

## Linting Architecture — Critical Notes

**none-ls is the linting layer, not nvim-lint.** Do not add nvim-lint back. The reason:

- none-ls registers as an LSP server and feeds diagnostics through Neovim's LSP protocol. This means diagnostics are version-aware — when you edit the buffer, stale diagnostics are automatically invalidated, just like any other LSP server.
- nvim-lint was tried and rejected: it uses `vim.diagnostic.set()` with raw line numbers and has no document version tracking, so diagnostics "float" to wrong line positions after edits and stay there until the next lint run completes. This is a known unfixed architectural limitation of nvim-lint.

**ansiblels has `validation.lint.enabled = false`** in its settings. This is intentional — both `ansiblels` and none-ls would otherwise both run ansible-lint, causing duplicate diagnostics. `ansiblels` handles completions, hover, go-to-definition; none-ls owns the ansible-lint diagnostic output.

## Code Style

- **Indentation**: 2 spaces, `expandtab = true`
- **Variables**: `snake_case`, always `local`
- **Strings**: Double quotes consistently
- **Plugin configs**: Return a lazy.nvim spec table; keybindings declared in the `keys` table with a `desc` field
- **Requires**: `local var = require("module")` at the top of functions/configs
- **Error handling**: `pcall()` for risky operations; `vim.notify()` for user-facing feedback

## Important Conventions

- Colorscheme is loaded in `init.lua` with a `pcall` fallback — keep this pattern when touching colors.
- New LSP servers go in `lua/plugins/lsp-config.lua` under `ensure_installed` and the `servers` table.
- New formatters go in `lua/plugins/conform.lua` under `formatters_by_ft`.
- New linters go in `lua/plugins/none-ls.lua` under the `sources` table using `null_ls.builtins.diagnostics.*` or `none-ls-extras`.
- `lazy-lock.json` is tracked in git to pin plugin versions.
- `schemastore.nvim` is used for jsonls and yamlls schema validation — keep this wired up when modifying those server configs.
