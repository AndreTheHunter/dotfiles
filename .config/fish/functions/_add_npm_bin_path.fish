function _add_npm_bin_path --on-variable PWD
	fish_add_path ./node_modules/.bin/
	for parent in (parents)
		fish_add_path {$parent}node_modules/node_modules/.bin/
	end
end

