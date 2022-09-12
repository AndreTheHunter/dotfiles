function npm_outdated
	npm outdated --global --parseable | ag --only-matching '(?<=/node_modules/).+?(?=:)'
end

