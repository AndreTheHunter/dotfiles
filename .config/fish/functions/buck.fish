# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.EIf0XP/buck.fish @ line 2
function buck
	set -x JAVA_HOME $JAVA_8_HOME
	command buck $argv
end
