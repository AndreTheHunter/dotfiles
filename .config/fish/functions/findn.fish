# Defined in - @ line 1
function findn --description 'alias findn find . -name '
	find . -name  $argv 2> /dev/null
end
