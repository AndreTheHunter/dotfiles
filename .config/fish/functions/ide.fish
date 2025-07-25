function ide
    set project (basename $PWD)
    if test -e "$project.sln"
        set cmd rider
        set args "$project.sln"
    else
        set cmd idea
    end
    if not set --query args
        if test (count $argv) -eq 0
            set args .
        else
            set args $argv
        end
    end
    set_color yellow
    echo "$cmd $args"
    set_color normal
    nohup $cmd $args >/dev/null &
    disown
end
