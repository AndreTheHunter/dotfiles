# Defined in - @ line 1
function whoami --description 'alias whoami id -un'
	id -un $argv;
end
