# Dotfiles

Personal configuration files for macOS, including Zsh setup and Powerlevel10k theme.  
Organized for easy setup and migration to new machines, with symlinked configs and template files for sensitive settings.

---

## Installing / Setting up

1. **Clone the repository:**

```zsh
git clone git@github.com:yourusername/dotfiles.git ~/.dotfiles
```

2. **Create symlinks for Zsh configs:**
```zsh
# Zsh entry file
ln -sf ~/.dotfiles/zsh/zshrc.main ~/.zshrc

# Powerlevel10k config
ln -sf ~/.dotfiles/zsh/.p10k.zsh ~/.p10k.zsh
```

3. ** Restart your terminal or reload Zsh:**
```zsh
exec zsh
```

## Notes

`.p10k.zsh` must be sourced after Powerlevel10k is installed.


