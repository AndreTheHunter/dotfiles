function complete-default -a cmd
	complete --no-files --command $cmd --arguments "($cmd --_completion)"
end
