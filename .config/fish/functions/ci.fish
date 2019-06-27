# Defined in - @ line 1
function ci 
	if command git is-git
		watch jci r --project (basename (pwd)) $argv;
	else
		watch jci r $argv;
	end
end
