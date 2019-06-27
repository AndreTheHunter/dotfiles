function retry
  eval $argv
  while test $status != 0
    eval $argv
  end
  return $status
end

