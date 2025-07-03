#shellcheck source-path=..
source "$HOME/.bash_functions/strict.bash"
source "$HOME/.bash_functions/require-var.bash"

gen-ssh() {
	local dest=$1
	local email=$2
	require-var dest email
	mkdir -p "$HOME/.ssh"
	cd "$HOME/.ssh"
	chmod go-rx .
	if [ ! -e "$dest" ]; then
		ssh-keygen -t ed25519 -b 4096 -C "$email" -f "$dest"
	fi
	ssh-add --apple-use-keychain "$dest"
	echo "SSH key: $dest"
	cat "$dest.pub"
}
