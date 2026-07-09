# Defined in - @ line 1
function reload --description 'reload shell and reset universal environment'
	set -e __my_env_initialized
	exec fish $argv
end
