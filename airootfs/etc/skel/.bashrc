# ~/.bashrc - KryptonOS Interactive Developer Shell
[[ $- != *i* ]] && return

# Developer Environment Variables
export EDITOR="nvim"
export VISUAL="code"
export PAGER="less"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export LANG="en_US.UTF-8"
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# Modern CLI Tool Replacements
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'
alias cat='bat --style=plain'
alias top='btop'
alias y='yazi'
alias v='nvim'
alias vim='nvim'
alias c='clear'

# Git Productivity Shortcuts
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit -a -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gl='git pull --rebase'
alias gd='git diff'
alias gds='git diff --staged'
alias glg='git log --graph --oneline --decorate --all'
alias lg='lazygit'

# Developer Helpers
alias code='code --no-sandbox'
alias py='python3'
alias pip='python3 -m pip'
alias venv='python3 -m venv .venv && source .venv/bin/activate'
alias activate='source .venv/bin/activate'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'

# Fast directory jumping with zoxide (if installed)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi

# Fuzzy Finder (fzf) integration
if command -v fzf &>/dev/null; then
    eval "$(fzf --bash 2>/dev/null)" || true
fi

# Fastfetch welcome banner (displays Arch Linux logo with system info)
if command -v fastfetch &>/dev/null; then
    fastfetch
fi

# Starship Prompt
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi
