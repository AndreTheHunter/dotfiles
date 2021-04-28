# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.cNEmdi/ide.fish @ line 2
function ide
	set -l args
	set -l cmd
	if test -d '.vscode';or test -e (basename (pwd)).csproj
		set cmd 'code'
	else
		set cmd 'idea'
	end
	if test (count $argv) -eq 0
		set args (pwd)
	else
		set args $argv
	end
	eval "command $cmd $args"
end
