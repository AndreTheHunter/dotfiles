#shellcheck source-path=..
source "$HOME/.bash_functions/strict.bash"
source "$HOME/.bash_functions/require-var.bash"

gen-gpg() {
	local email key_id
	email=$1
	require-var NAME gitconfig email
	cd "$HOME/.gnupg"
	chmod go-rx .
	if ! gpg --list-key "<$email>" >/dev/null; then
		gpg --quick-gen-key "$NAME () <$email>" default default 1y
	fi
	key_id=$(gpg --list-secret-keys --keyid-format=long --list-options=show-only-fpr-mbox "<$email>" | awk '{print $1}')
	echo "GPG key: $email $key_id"
	if [[ "$(git config get --file "$gitconfig" user.signingkey)" != "$key_id" ]]; then
		echo 'Updating git'
		git config set --file "$gitconfig" user.signingkey "$key_id"
	fi
	gpg --armor --export "$key_id"
	gpgconf --reload gpg-agent
	echo test | gpg -e -r "<$email>" | gpg -d >>/dev/null
}
