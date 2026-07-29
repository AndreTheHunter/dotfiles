function show
    message "$argv"
    eval (string escape $argv)
end
