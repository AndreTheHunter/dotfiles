# Defined via `source`
function llint --wraps='lein check-all' --description 'alias llint lein check-all'
  lein check-all $argv; 
end
