function project
	clear
	set --function file (basename $PWD)
	if test -e "$file.ps1"
		./$file.ps1 $argv
	else if test -e "$file.sh"
		./$file.sh $argv
	else if test -e "$file.clj"
		./$file.clj $argv
	else if test -e Justfile
		just $argv
	else if test -e Makefile
		make $argv
	else if test -e build.boot
		boot $argv
	else if test -e project.clj
		lein $argv
	else if test -e gulpfile.js;or test -e gulpfile.babel.js
		npx gulp $argv
	else if test -e package.json
		if test -e yarn.lock
			yarn $argv
		else
			npm $argv
		end
	else if test -e pom.xml
		mvn $argv
	else
		err "Not a project"
	end
end
