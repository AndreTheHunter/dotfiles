function pd-ack-all --wraps='pd incident list --me --statuses=triggered --pipe|pd incident acknowledge --pipe' --description 'alias pd-ack-all pd incident list --me --statuses=triggered --pipe|pd incident acknowledge --pipe'
  pd incident list --me --statuses=triggered --pipe|pd incident acknowledge --pipe $argv
        
end
