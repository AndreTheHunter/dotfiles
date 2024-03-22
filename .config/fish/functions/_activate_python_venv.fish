function _activate_python_venv --on-variable PWD
    if set --query VIRTUAL_ENV
        if not functions --query deactivate
            source "$VIRTUAL_ENV/bin/activate.fish"
        end
        if not is-parent "$VIRTUAL_ENV/.." $PWD; and functions --query deactivate
            deactivate
        end
    end
    for dir in $PWD (parents)
        for venv in venv .venv .ve
            set --local venv_dir "$dir/$venv"
            if test "$VIRTUAL_ENV" != "$venv_dir"
                set activate "$venv_dir/bin/activate.fish"
                if test -e "$activate"
                    source "$activate"
                    return $status
                end
            end
        end
    end
end
