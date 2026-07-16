function __project_completions
    set -l cmd_to_run (project_delegate)
    test -z "$cmd_to_run"; and return

    # godot delegate in 'project' script doesn't pass arguments
    if test "$cmd_to_run" = "godot"
        return
    end

    set -l cmd (commandline -cp)
    set -l joined_cmd (string join ' ' $cmd_to_run)
    set -l new_cmd (string replace -r '^\s*\S+' "$joined_cmd" "$cmd")

    complete -C"$new_cmd"
end

# Reset any previous project completion definitions.
complete -e -c project
complete -e -c p

# Dynamic delegation
complete -c project -f -a '(__project_completions)'
complete -c p --wraps project
