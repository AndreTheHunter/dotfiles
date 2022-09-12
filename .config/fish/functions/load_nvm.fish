function load_nvm --on-variable="PWD"
  set -l nvmrc_path (nvm_find_nvmrc)
  if test -n "$nvmrc_path"
  	set -l nvmrc_version (cat $nvmrc_path)
    set -l nvmrc_node_version (nvm version $nvmrc_version)
    if test "$nvmrc_node_version" = "N/A"
      nvm install $nvmrc_version
			nvm use $nvmrc_version
    else 
    	if test "$nvmrc_node_version" != (nvm version)
				nvm use $nvmrc_node_version
			end
    end
  else 
  	if test (nvm version default) != (nvm version)
			nvm use default
		end
  end
end

