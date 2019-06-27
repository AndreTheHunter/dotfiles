# Defined in - @ line 1
function g --description 'alias g git' --wraps=git
	git  $argv;
end
