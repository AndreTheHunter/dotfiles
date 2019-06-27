# Defined in - @ line 1
function updatedb --description 'alias updatedb sudo /usr/libexec/locate.updatedb'
	sudo /usr/libexec/locate.updatedb $argv;
end
