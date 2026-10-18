# KryptonOS .zshrc

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
alias y='yazi'
alias lg='lazygit'
alias update='sudo pacman -Syu'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
alias krypton-install='sudo archinstall'

# Yazi wrapper: changes directory when exiting yazi with q
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Keybindings
bindkey -e

# Fastfetch welcome banner
if [[ -o interactive ]]; then
    fastfetch
fi

# Initialize Starship Prompt
eval "$(starship init zsh)"

# Initialize Zoxide (Smart cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd="z"
fi

# Initialize fzf keybindings
if command -v fzf &> /dev/null; then
    source <(fzf --zsh) 2>/dev/null || true
fi
