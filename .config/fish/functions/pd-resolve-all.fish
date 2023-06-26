function pd-resolve-all \
	--wraps='pd incident list --me --pipe | pd incident resolve --pipe' \
	--description 'alias pd incident list --me --pipe | pd incident resolve --pipe'
	pd incident list --me --pipe | pd incident resolve --pipe
end
