function pd-resolve-all \
	--wraps='pd incident list --pipe | pd incident resolve --pipe' \
	--description 'alias pd incident list --pipe | pd incident resolve --pipe'
	pd incident list --pipe | pd incident resolve --pipe
end
