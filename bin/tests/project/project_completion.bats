#!/usr/bin/env bats

setup() {
    export PATH="$HOME/bin:$PATH"
    TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "completion for just project" {
    touch Justfile
    # just has recipes, let's add one
    echo "hello:" > Justfile
    echo "  echo hello" >> Justfile

    run fish -c "source ~/.config/fish/completions/project.fish; complete -C'project '"
    [ "$status" -eq 0 ]
    [[ "$output" == *"hello"* ]]
}

@test "completion for lein project" {
    touch project.clj
    # We won't actually run lein completions here if lein is not installed or slow,
    # but we can check if it tries to call it.
    # Actually, lein is likely installed.
    run fish -c "source ~/.config/fish/completions/project.fish; complete -C'project '"
    [ "$status" -eq 0 ]
}

@test "no just error in lein project" {
    touch project.clj
    run fish -c "source ~/.config/fish/completions/project.fish; complete -C'project '"
    [ "$status" -eq 0 ]
    [[ ! "$output" == *"error: no justfile found"* ]]
}

@test "support for lowercase justfile" {
    touch justfile
    echo "hello:" > justfile
    run fish -c "source ~/.config/fish/completions/project.fish; complete -C'project '"
    [[ "$output" == *"hello"* ]]
}

@test "support for directory-named .sh script" {
    mkdir -p my_sh_project
    cd my_sh_project
    touch my_sh_project.sh
    chmod +x my_sh_project.sh
    run fish -c "source ~/.config/fish/completions/project.fish; __project_delegate_command"
    [ "$output" = "./my_sh_project.sh" ]
}

@test "does not match 'run' if it is a directory" {
    mkdir run
    run fish -c "source ~/.config/fish/completions/project.fish; __project_delegate_command"
    [ "$output" != "./run" ]
}

@test "p command uses dynamic completions" {
    touch Justfile
    echo "hi:" > Justfile
    run fish -c "source ~/.config/fish/completions/project.fish; complete -C'p '"
    [[ "$output" == *"hi"* ]]
}
