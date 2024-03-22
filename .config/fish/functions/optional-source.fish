function optional-source
    set file "$argv"
    if test -e $file
        source $file
    end
end
