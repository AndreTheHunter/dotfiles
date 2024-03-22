function add-suffix
    set --local suffix $argv[1]
    for word in $argv[2..]
        echo -n $word
        if string match --invert --quiet "*$suffix" $word
            echo -n $suffix
        end
    end
end
