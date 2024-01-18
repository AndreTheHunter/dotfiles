function _add_npm_bin_path --on-variable PWD
	set --local dir '/node_modules/.bin'
	set --local len (string length $dir)
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

