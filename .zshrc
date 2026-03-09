source ~/.aliases
echo "from zshrc"

# uv Python - must come before homebrew
export PATH="$HOME/.local/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"

eval "$(mise activate zsh)"
