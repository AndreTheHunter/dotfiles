# yarn completions for fish shell
# This file adds project scripts to yarn completions.
# Built-in commands and options are handled by carapace (if installed).

function __fish_yarn_print_scripts
    set -l file package.json
    set -l dir $PWD
    while test "$dir" != "/"
        if test -f "$dir/$file"
            # package.json is JSON, so use jq (the standard JSON tool) rather than yq
            if command -v jq >/dev/null
                jq -r '.scripts | keys[]' "$dir/$file" 2>/dev/null
            end
            return
        end
        set dir (dirname "$dir")
    end
end

# Provide scripts for 'yarn run <script>'
complete -c yarn -f -n "__fish_seen_subcommand_from run" -a "(__fish_yarn_print_scripts)"

# Provide scripts as shorthand 'yarn <script>'
complete -c yarn -f -n "__fish_use_subcommand" -a "(__fish_yarn_print_scripts)"
