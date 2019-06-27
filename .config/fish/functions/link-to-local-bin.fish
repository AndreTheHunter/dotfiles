function link-to-local-bin
  #ln -s (which grealpath) /usr/local/bin/realpath
  set ex $argv[1]
  set name $argv[2]
  set dest /usr/local/bin/$name
  if test -e $dest
    err "Error: $dest already exists"
    return 1
  end
  ln -s (which $ex) $dest
end
