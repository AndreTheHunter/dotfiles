#vim: syntax=sh
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="$PATH:/$HOME/.docker/bin"
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="$PATH:/Users/andre/.lmstudio/bin"

#JetBrains
if is-mac; then
	export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
else
	export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"
fi

command -v mise >/dev/null && eval "$(mise activate "${ZSH_VERSION:+zsh}${BASH_VERSION:+bash}")"

. "$HOME/secret/.profile"
