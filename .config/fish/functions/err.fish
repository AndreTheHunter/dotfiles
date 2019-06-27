function err
	function do
		set_color red;echo $argv >&2;set_color normal
	end
	do-input $argv
end
