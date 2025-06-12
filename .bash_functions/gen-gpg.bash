#shellcheck source-path=..
source "$HOME/.bash_functions/strict.bash"
source "$HOME/.bash_functions/require-var.bash"

gen-gpg() {
	local name=$1
	local email=$2
	local gitconfig=$3
	require-var name email gitconfig
	cd "$HOME/.gnupg"
	chmod go-rx .
	if ! gpg --list-key "<$email>" >/dev/null; then
		gpg --quick-gen-key "$name () <$email>" default default 1y
	fi
	local key_id=$(gpg --list-secret-keys --keyid-format=long --list-options=show-only-fpr-mbox "<$email>" | awk '{print $1}')
	echo "GPG key: $email $key_id"
	if [[ "$(git config get --file "$gitconfig" user.signingkey)" != "$key_id" ]]; then
		echo 'Updating git'
		git config set --file "$gitconfig" user.signingkey "$key_id"
	fi
	gpg --armor --export "$key_id"
	gpgconf --reload gpg-agent
	echo test | gpg -e -r "<$email>" | gpg -d >>/dev/null
}
