# Dotfiles

Personal configuration files for macOS, including Zsh setup and the Powerlevel10k theme.
Organized for easy setup and migration to new machines, using symlinked configurations and template files for sensitive settings.

> **Note — clone directory:** This README assumes the repository is cloned into `~/.dotfiles`. If you clone it elsewhere, replace `~/.dotfiles` in all commands with your actual path. For example, if you cloned into `~/projects/dotfiles`:
>
> ```zsh
> ln -sf ~/projects/dotfiles/zsh/.zshrc ~/.zshrc
> ```

---

## Prerequisites

* [`oh-my-zsh`](https://github.com/ohmyzsh/ohmyzsh) installed

---

## Installation / Setup

### 1. Clone the repository

Clone this repository into your home directory (or wherever you prefer):

```zsh
git clone https://github.com/rudyzac/.dotfiles.git ~/.dotfiles
```

If you clone the repository into a different directory, see the note at the top of this file.

### 2. Create a symlink for `.zshrc`

```zsh
ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
```

### 3. Install Powerlevel10k

Run:

```zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
```

Full installation instructions are available [here](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#oh-my-zsh).

Then create a symlink to the Powerlevel10k configuration file:

```zsh
ln -sf ~/.dotfiles/zsh/.p10k.zsh ~/.p10k.zsh
```

### 4. Install fonts for Powerlevel10k

Run the following command and answer **Yes** when asked whether to install **Meslo Nerd Font**:

```zsh
p10k configure
```

---

## For VSCode Users: fixing Powerlevel10k icons in the VSCode terminal

If you see placeholder symbols instead of icons in the VSCode terminal while using Powerlevel10k (for example, ``), it usually means the terminal is not using a Nerd Font. This can happen even if everything works correctly in iTerm2 or Ghostty.

### How to fix

1. Ensure the Nerd Font you use in iTerm2 also works in VS Code. **MesloLGS NF** is the recommended font.

2. Open VS Code settings (`Ctrl+,`) and search for **Terminal Font Family**.

3. Set it explicitly to:

   ```
   MesloLGS NF
   ```

4. Restart the VS Code terminal (or VS Code entirely) to apply the changes.

After this, all Powerlevel10k icons should render correctly in the VS Code terminal.

---

## Neovim Configuration

### Prerequisites

- **Neovim** (a recent version — the Treesitter config targets parser ABI 15).
- A **C compiler** (`cc`/`clang`) so Treesitter can compile parsers. On macOS this comes with the Xcode Command Line Tools (`xcode-select --install`).
- **Node.js** and **tree-sitter CLI**. Most Treesitter parsers ship pre-generated and only need the C compiler, but a few (e.g. Swift) are generated from their grammar at install time, which requires the `tree-sitter` CLI plus a Node runtime to evaluate the grammar:

  ```zsh
  brew install node
  npm install -g --allow-scripts=tree-sitter-cli tree-sitter-cli
  ```

  Notes:
  - `--allow-scripts=tree-sitter-cli` is required on npm 11+, which blocks the package's install script by default — that script is what downloads the CLI's native binary.
  - Verify the CLI is on your `PATH`: `tree-sitter --version`.

### Setup

1. Symlink the Neovim configuration directory:

   ```zsh
   ln -sfn ~/.dotfiles/nvim ~/.config/nvim
   ```

2. Launch Neovim. On first start, [lazy.nvim](https://github.com/folke/lazy.nvim) bootstraps itself and installs all plugins automatically, then runs `:TSUpdate` to build the Treesitter parsers.

3. (Optional) Verify Treesitter is healthy:

   ```
   :checkhealth nvim-treesitter
   ```

### Terraform LSP

The Terraform language server is configured in `nvim/lua/config/lsp.lua`, but the
binaries it drives are not bundled — install them from HashiCorp's Homebrew tap:

```zsh
brew install hashicorp/tap/terraform-ls
brew install hashicorp/tap/terraform
```

Notes:

- Both come from `hashicorp/tap`, not homebrew-core.
- `terraform-ls` is the language server Neovim launches (`terraform-ls serve`); it
  must be on your `PATH`. Verify with `terraform-ls --version`.
- The `terraform` CLI is a separate requirement: `terraform-ls` shells out to it to
  initialise modules and read provider schemas, so completion for resources and
  attributes stays empty without it. Verify with `terraform version`.
- The `terraform` and `hcl` Treesitter parsers are installed automatically on first
  launch — nothing to do by hand.

To confirm the server is running, open a `.tf` file and run `:checkhealth vim.lsp`;
`terraformls` should be listed as an attached client.

### JavaScript/TypeScript LSP

Two servers are configured in `nvim/lua/config/lsp.lua` and work together — `vtsls`
for type errors and navigation, `eslint` for lint diagnostics and autofixes. Neither
binary is bundled; install both with Homebrew:

```zsh
brew install vtsls
brew install vscode-langservers-extracted
```

Both pull in `node` if it is not already present.

#### vtsls

- `vtsls` wraps VS Code's own TypeScript extension, driving the same `tsserver`
  underneath as the more common `ts_ls`. It is chosen here for monorepos: it resolves
  each package's `tsconfig.json` inside one server instance, where `ts_ls` spawns a
  separate client per project root. Do not enable `ts_ls` at the same time — the two
  would double every diagnostic.
- Unlike `ts_ls`, the Homebrew formula does **not** depend on `typescript`. `vtsls`
  bundles its own copy of the TypeScript library, and prefers a project-local
  `node_modules/typescript` when one exists. A global `brew install typescript` is
  therefore optional — useful only if you want `tsc` on your `PATH` for command-line
  builds, not for the editor.
- Be aware the bundled copy is pinned well behind current TypeScript (5.9.x, against
  7.x on npm). That only matters for a project using syntax newer than the bundled
  version understands, and the fix is the normal one: run `npm install` so the repo
  has its own `node_modules/typescript`, which `vtsls` picks up in preference.
- It attaches to `.js`, `.jsx`, `.ts`, `.tsx`, `.mjs` and `.cjs` buffers. The project
  root is the nearest directory holding a package-manager lockfile
  (`package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `bun.lockb`, `bun.lock`) or
  `.git`, falling back to the current working directory — note it keys off lockfiles,
  not `tsconfig.json`. Deno projects are deliberately skipped: if a
  `deno.json`/`deno.lock` sits closer to the file than any lockfile, it does not start.
- Verify with `vtsls --version` (prints `0.3.0`).

#### eslint

- The server is `vscode-eslint-language-server`, one of several shipped in the
  `vscode-langservers-extracted` formula. That same formula provides
  `vscode-json-language-server`, which the `jsonls` config in `lsp.lua` needs, so this
  one command activates both.
- It starts only when it finds an eslint config (`eslint.config.*`, `.eslintrc*`) in
  the file's directory tree, and `workspace_required` keeps it from attaching to loose
  buffers. Projects with no eslint setup are simply unaffected — no spurious
  diagnostics.
- It prefers the project-local `node_modules/.bin/vscode-eslint-language-server` when
  one is present, so each repo lints with its own eslint version and your editor
  matches CI.
- `:LspEslintFixAll` applies every autofixable rule to the current buffer.
- `lsp.lua` overrides one shipped default: `settings.format = false`. eslint otherwise
  advertises itself as a formatter, and since both servers attach to the same buffer,
  `<leader>cf` would run two formatters over it and let them produce conflicting
  edits. Formatting is left to `vtsls`; use `:LspEslintFixAll` for eslint's fixes.
  Drop that setting to restore the default.
- It does not bundle ESLint itself — it loads the project's own copy from
  `node_modules`. In a repo that has an eslint config but has never been
  `npm install`ed you will get an "Unable to find ESLint library" warning on open;
  running `npm install` resolves it.
- Do **not** try to verify this one with `--version`. Neither server in this formula
  accepts it: they call `createConnection()` at startup and abort with "Connection
  input stream is not set" unless given `--stdio`. That error means the binary is
  installed and working, not broken. Check the install with
  `brew list --versions vscode-langservers-extracted` instead.

The `javascript`, `typescript` and `tsx` Treesitter parsers are installed
automatically on first launch — nothing to do by hand.

To confirm both are running, open a `.ts` file inside an eslint-configured project and
run `:checkhealth vim.lsp`; `vtsls` and `eslint` should both be listed as attached
clients.

#### Installing via npm instead

```zsh
npm install -g @vtsls/language-server vscode-langservers-extracted
```

Global npm packages are not covered by `brew upgrade`; update them with:

```zsh
npm outdated -g --depth=0                    # see what is behind
npm update -g                                # respects semver ranges
npm install -g <pkg>@latest                  # force newest across a major bump
```

Note that `npm update -g` will not cross a major version — a major bump needs the
explicit `@latest` form.

Do not mix the two installation methods: whichever of Homebrew's or npm's bin
directory comes first on your `PATH` wins, and you will be debugging a version you did
not think you were running. `which -a vtsls vscode-eslint-language-server` shows every
copy on your `PATH`.

### Colorschemes

Two are installed. VS Code Dark+ (`vscode`) is the active default; Tokyo Night is available too. Switch at any time with:

```
:colorscheme vscode
:colorscheme tokyonight
```

---

## Scripts

The `bin/` directory holds small helper scripts. `install.sh` symlinks each one into `~/.local/bin` (without the `.sh` extension), so they're available on your `PATH`.

Available scripts:

- **`git-prune-merged`** — deletes local branches already merged into the remote's default branch (`main`/`master`), keeping your branch list tidy after PRs are merged. The default branch is detected automatically and the remote is assumed to be `origin`. The current branch and any branch checked out in another worktree are skipped. Because it's named `git-*` and on your `PATH`, Git picks it up as a subcommand: run it as `git prune-merged`. A `gpm` alias is also defined in `.zshrc`.

### Installation

1. Run the installer:

   ```zsh
   ~/.dotfiles/bin/install.sh
   ```

2. Ensure `~/.local/bin` is on your `PATH`. The provided `.zshrc` already does this:

   ```zsh
   export PATH="$HOME/.local/bin:$PATH"
   ```

3. Verify:

   ```zsh
   git prune-merged   # or: gpm
   ```
