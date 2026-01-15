#shellcheck source-path=..
source "$HOME/.bash_functions/strict.bash"
source "$HOME/.bash_functions/require-var.bash"

key-id() {
  local email=$1
  gpg --list-secret-keys --keyid-format=long --list-options=show-only-fpr-mbox "<$email>" | awk '{print $1}'
}

gen-gpg() {
  local existing_key key_id
  local name=$1
  local email=$2
  local gitconfig=$3
  require-var name email gitconfig
  cd "$HOME/.gnupg"
  chmod go-rx .
  existing_key="$(gpg --list-key "<$email>" || echo)"
  if [ -z "$existing_key" ]; then
    gpg --quick-gen-key "$name () <$email>" default default 1y
  elif [[ $existing_key =~ "expired" ]]; then
    key_id=$(key-id "$email")
    gpg --quick-set-expire "$key_id" 1y
    echo "Key renewed for 1 year"
  fi
  key_id=$(key-id "$email")
  echo "GPG key: $email $key_id"
  if [[ "$(git config get --file "$gitconfig" user.signingkey)" != "$key_id" ]]; then
    echo 'Updating git'
    git config set --file "$gitconfig" user.signingkey "$key_id"
  fi
  gpg --armor --export "$key_id"
  gpgconf --reload gpg-agent
  echo test | gpg -e -r "<$email>" | gpg -d >>/dev/null
}
