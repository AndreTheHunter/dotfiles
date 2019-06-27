#!/usr/bin/env bash
source=~/.lein/credentials.clj
dest=~/.lein/credentials.clj.gpg
rm $dest
gpg --default-recipient-self -e $source > $dest && rm $source
