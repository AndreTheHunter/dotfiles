#vim: syntax=sh
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

#Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

#JetBrains
if is-mac; then
	export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
else
	export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"
fi

#asdf
if is-mac; then
	ASDF_DIR="$(brew --prefix asdf)/libexec"
else
	ASDF_DIR="$HOME/.asdf"
fi
export ASDF_DIR
#shellcheck source=/opt/homebrew/opt/asdf/libexec/asdf.sh
. "$ASDF_DIR/asdf.sh"

#NVM
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

#shellcheck source=.afm-git-configrc
. ~/.afm-git-configrc


# Added by Toolbox App
export PATH="$PATH:/Users/andre/Library/Application Support/JetBrains/Toolbox/scripts"

