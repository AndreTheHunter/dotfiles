#vim: syntax=sh
export PATH="$PATH:$HOME/bin"
#JetBrains
if is-mac;then
	export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
else
	export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"
fi
#asdf
if is-mac;then
	ASDF_DIR="$(brew --prefix asdf)/libexec"
else
	ASDF_DIR="$HOME/.asdf"
fi
export ASDF_DIR
#shellcheck source=/opt/homebrew/opt/asdf/libexec/asdf.sh
source "$ASDF_DIR/asdf.sh"
