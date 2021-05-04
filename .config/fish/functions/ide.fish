# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.gPiHdl/ide.fish @ line 2
function ide
	set project (basename (pwd))
	if test -e "$project.sln"
		set cmd 'rider'
		set args "$project.sln"
	else if test -d '.vscode';or test -e "$project.csproj"
		set cmd 'code'
	else
		set cmd 'idea'
	end
	if not set --query args
		if test (count $argv) -eq 0
			set args .
		else
			set args $argv
		end
	end
	set cmd "$cmd $args"
	set_color yellow
	echo "$cmd"
	set_color normal
	eval "command $cmd"
end
