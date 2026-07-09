function optional-source --description 'Source a file if it exists'
    set -l file $argv[1]
    test -e "$file"; and source "$file"
end
