# Dotfiles

Personal configuration files for macOS, including Zsh setup and the Powerlevel10k theme.
Organized for easy setup and migration to new machines, using symlinked configurations and template files for sensitive settings.

---

## Prerequisites

* [`oh-my-zsh`](https://github.com/ohmyzsh/ohmyzsh) installed

---

## Installation / Setup

### 1. Clone the repository

Clone this repository into your home directory (or wherever you prefer):

```zsh
git clone <repo-url> ~/.dotfiles
```

If you clone the repository into a different directory, please see the Appendix (end of the file).

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

1. Install Neovim if it is not already installed.

2. Create the Neovim configuration directory:

   ```zsh
   mkdir -p ~/.config/nvim
   ```

3. Create `init.lua`:

   ```zsh
   touch ~/.config/nvim/init.lua
   ```

4. Create a symlink to the Neovim configuration file:

   ```zsh
   ln -sf ~/.dotfiles/nvim/init.lua ~/.config/nvim/init.lua
   ```

5. Restart your terminal or reload Zsh:

   ```zsh
   exec zsh
   ```

## Appendix: Custom Clone Directory

This README assumes that the repository is cloned into `~/.dotfiles`.

If you clone the repository into a different directory, make sure to replace `~/.dotfiles` in all commands with the actual path where you cloned the repository.

For example, if you cloned the repository into `~/projects/dotfiles`, update the commands accordingly:

```zsh
ln -sf ~/projects/dotfiles/zsh/.zshrc ~/.zshrc
```
