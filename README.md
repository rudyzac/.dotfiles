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

### Colorschemes

Two are installed. VS Code Dark+ (`vscode`) is the active default; Tokyo Night is available too. Switch at any time with:

```
:colorscheme vscode
:colorscheme tokyonight
```
