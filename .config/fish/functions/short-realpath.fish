function short-realpath
    echo (string replace --regex "^$HOME" '~' -- (path resolve $argv))
end
