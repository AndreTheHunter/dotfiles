function pf-local -d ''
	set pfFile /etc/pf-local.conf
	switch $argv[1]
		case 'start'
			sudo pfctl -ef $pfFile
		case 'stop'
			sudo pfctl -df $pfFile
			# stop and clear
			# sudo pfctl -d
			# XXX is flushing required?
			# sudo pfctl -F all -f /etc/pf.conf
		case '*'
			err 'Command "'$argv'" not recognised'
	end
end
