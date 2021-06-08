function watch-cmd
	ag -l | entr -ccsn "$argv"
end
