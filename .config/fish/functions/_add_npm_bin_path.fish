function _add_npm_bin_path --on-variable PWD
	set --function dir '/node_modules/.bin'
	set --function len (string length $dir)
	#TODO check paths in parallel and create list of paths to remove
	for path in $fish_user_paths
		if string match --quiet "*$dir" $path
			set --local parent (string sub --end -$len $path)
			if string match --quiet --invert "$parent/*" $PWD
				set --local index (contains --index $path $fish_user_paths)
      	set --erase --global fish_user_paths[$index]	
			end
		end
	end
	fish_add_path --global "$PWD$dir"
	for parent in (parents)
		fish_add_path --global "$parent$dir"
	end
end

