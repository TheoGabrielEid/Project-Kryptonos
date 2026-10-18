# KryptonOS .zshrc

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory sharehistory incappendhistory

# Modern Aliases
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first'
alias tree='eza --tree --icons'
alias cat='bat --style=plain'
alias grep='rg'
alias find='fd'
alias top='btop'
alias y='yazi'
alias krypton-install='sudo calamares'

# Keybindings
bindkey -e

# Fastfetch welcome
if [[ -o interactive ]]; then
    fastfetch
fi

# Initialize Starship
eval "$(starship init zsh)"

# Initialize Zoxide
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd="z"
fi
