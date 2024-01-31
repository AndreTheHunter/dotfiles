#!/usr/bin/env bash
# shellcheck source=../strict.bash
source ~/strict.bash
cd "$(dirname "$0")"
mkdir -p Spoons

install-official () {
	(
		cd Spoons
		file=$1.spoon.zip
		aria2c -q "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/$file"
		unzip -qo "$file"
		trap 'rm -rf "$(pwd)/$file"' EXIT
	)
}

install-official 'ReloadConfiguration'
