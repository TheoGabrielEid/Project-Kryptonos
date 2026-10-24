# KryptonOS .zshrc - Interactive Developer Shell

# Developer Environment Variables
export EDITOR="nvim"
export VISUAL="code --no-sandbox"
export PAGER="less"
export LANG="en_US.UTF-8"

# Language Ecosystems & Toolchain PATHs (Node, Rust, Go, Python, Lua)
export PATH="$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
export GOPATH="$HOME/go"
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"

# History
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt appendhistory sharehistory incappendhistory hist_ignore_dups hist_ignore_space

# Load Zsh Plugins (Autosuggestions & Syntax Highlighting)
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Modern Daily-Driver Aliases
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias tree='eza --tree --icons'
alias cat='bat --style=plain'
alias grep='rg'
alias find='fd'
alias top='btop'
alias v='nvim'
alias vim='nvim'
alias c='clear'
alias y='yazi'
alias lg='lazygit'
alias kproj='krypton-project'

# Quick Language & Runtime Aliases
alias py="python3"
alias pip="pip3"
alias d="docker"
alias dco="docker-compose"
alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dstop='docker stop $(docker ps -q) 2>/dev/null || true'
alias dclean="docker system prune -f"
alias serve="python3 -m http.server 8000"
alias ports="ss -tulpn"
alias hr="hyprctl reload"

# Git shortcuts
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gl='git pull --rebase'
alias gd='git diff'
alias gds='git diff --staged'
alias glg='git log --graph --oneline --decorate --all'

# Keybindings
bindkey -e

# Fastfetch welcome banner
if [[ -o interactive ]]; then
    fastfetch
fi

# Initialize Starship Prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Initialize Zoxide (Smart cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd="z"
fi

# Initialize fzf keybindings
if command -v fzf &> /dev/null; then
    source <(fzf --zsh) 2>/dev/null || true
fi
