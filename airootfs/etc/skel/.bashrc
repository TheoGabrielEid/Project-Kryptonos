# ~/.bashrc - KryptonOS Interactive Developer Shell
[[ $- != *i* ]] && return

# Developer Environment Variables
export EDITOR="nvim"
export VISUAL="code --no-sandbox"
export PAGER="less"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export LANG="en_US.UTF-8"
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# Language Ecosystems & Toolchain PATHs (Node, Rust, Go, Python, Lua)
export PATH="$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
export GOPATH="$HOME/go"
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"

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

# Quick Language Aliases
alias py="python3"
alias pip="pip3"
alias d="docker"
alias dco="docker-compose"

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

# Fastfetch Banner on Interactive Terminal Launch
if [ -n "$PS1" ] && [ -z "$VIRTUAL_ENV" ] && [ "$TERM" != "dumb" ]; then
    fastfetch
fi

# Starship Prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# Zoxide (Smart cd)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
    alias cd="z"
fi

# FZF Shell Integration
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash 2>/dev/null || true)"
fi
