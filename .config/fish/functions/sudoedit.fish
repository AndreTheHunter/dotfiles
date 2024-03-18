function sudoedit --wraps='sudo -e' --description 'alias sudoedit=sudo -e'
  sudo --edit $argv
end
