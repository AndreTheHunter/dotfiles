#vim: syntax=bash
export PATH="$PATH:$HOME/bin"
#JetBrains
if is-mac;then
	export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
else
	export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"
fi
#asdf
if is-mac;then
	export ASDF_DIR="$(brew --prefix asdf)/libexec"
else
	export ASDF_DIR="$HOME/.asdf"
fi
source "$ASDF_DIR/asdf.sh"
