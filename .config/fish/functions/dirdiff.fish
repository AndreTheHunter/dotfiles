function dirdiff
    vim $argv[3..] -c "DirDiff $argv[1] $argv[2]"
end
