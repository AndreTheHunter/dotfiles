function watch-cmd
	clear
	ag -l | entr -ccsn "$argv"
end
