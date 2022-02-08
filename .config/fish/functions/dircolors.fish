function dircolors --wraps=gdircolors --description 'alias dircolors=gdircolors'
	if is-mac
		gdircolors $argv; 
	else
		command dircolors $argv; 
	end
end
