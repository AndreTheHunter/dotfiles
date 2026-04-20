# Keep behavior aligned with /Users/andre/bin/project: first matching branch wins.
function __project_delegate_target
    if test -x ./run
        echo run
    else if test -f Justfile
        echo just
    else if test -f Makefile
        echo make
    else if test -f build.boot
        echo boot
    else if test -f project.clj
        echo lein
    else if test -f gulpfile.js; or test -f gulpfile.babel.js
        echo gulp
    else if test -f package.json
        if test -f package-lock.json
            echo npm
        else
            echo yarn
        end
    else if test -f pom.xml
        echo mvn
    else if test -d project.godot
        echo godot
    end
end

function __project_target_is
    set -l expected $argv[1]
    set -l actual (__project_delegate_target)
    string match -q -- "$expected" "$actual"
end

# Reset any previous project completion definitions.
complete -e -c project

# Delegate completion to whichever command `project` would run.
complete -c project -n '__project_target_is run' -w run
complete -c project -n '__project_target_is just' -w just
complete -c project -n '__project_target_is make' -w make
complete -c project -n '__project_target_is boot' -w boot
complete -c project -n '__project_target_is lein' -w lein
complete -c project -n '__project_target_is gulp' -w gulp
complete -c project -n '__project_target_is npm' -w npm
complete -c project -n '__project_target_is yarn' -w yarn
complete -c project -n '__project_target_is mvn' -w mvn
complete -c project -n '__project_target_is godot' -w godot
