# Keep behavior aligned with /Users/andre/bin/project: first matching branch wins.
function __project_delegate_command
    if test -f ./run; and test -x ./run
        echo "./run"
    else if test -f Justfile; or test -f justfile
        echo just
    else if test -f Makefile; or test -f makefile
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
    else
        set -l dir (basename $PWD)
        if test -f "$dir.ps1"; and test -x "$dir.ps1"
            echo "./$dir.ps1"
        else if test -f "$dir.sh"; and test -x "$dir.sh"
            echo "./$dir.sh"
        else if test -f "$dir.clj"; and test -x "$dir.clj"
            echo "./$dir.clj"
        end
    end
end

function __project_completions
    set -l cmd_to_run (__project_delegate_command)
    test -z "$cmd_to_run"; and return

    # godot delegate in 'project' script doesn't pass arguments
    if test "$cmd_to_run" = "godot"
        return
    end

    set -l cmd (commandline -cp)
    # Replace the command 'project' or 'p' with the delegate command.
    # We use a regex to replace the first word on the line.
    set -l new_cmd (string replace -r '^\s*\S+' "$cmd_to_run" "$cmd")

    complete -C"$new_cmd"
end

# Reset any previous project completion definitions.
complete -e -c project
complete -e -c p

# Dynamic delegation
complete -c project -f -a '(__project_completions)'
complete -c p --wraps project
