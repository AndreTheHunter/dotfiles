# Navigate to the git repository root directory
# If in a submodule, it navigates to the parent repository root instead
function cdg
    if git-is-repo
        # Check if we're in a submodule by looking for .git file (not directory)
        if test -f .git
            # Read the .git file to get the actual git directory path
            set --local git_dir (string replace "gitdir: " "" < .git)
            # If the git directory contains .git/modules, we're in a submodule
            if string match -q "*/.git/modules/*" "$git_dir"
                # Navigate to the parent repository
                set --local parent_repo (string replace -r "\.git/modules/.*" "" "$git_dir")
                if test -d "$parent_repo"
                    show cd "$parent_repo"
                    return
                end
            end
        end
        set --local toplevel (git rev-parse --show-cdup 2>/dev/null)
        if test $status -eq 0; and test -n "$toplevel"
            show cd $toplevel
        end
    end
end
