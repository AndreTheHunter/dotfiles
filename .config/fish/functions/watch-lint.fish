# Defined via `source`
function watch-lint --wraps='watch-cmd p lint' --description 'alias watch-lint watch-cmd p lint'
  watch-cmd p lint $argv; 
end
