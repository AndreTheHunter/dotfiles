#!/usr/bin/env bash
# shellcheck source=/Users/andre/strict.bash
source ~/strict.bash
cd "$(dirname "$0")"
install-official () {
	(
		cd Spoons
		svn export --force "https://github.com/Hammerspoon/Spoons/trunk/Source/$1.spoon/"
	)
}
install-official 'ReloadConfiguration'
