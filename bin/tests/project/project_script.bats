#!/usr/bin/env bats

setup() {
    export PATH="$HOME/bin:$PATH"
    TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"

    # Mock show function to just echo what it would run
    # Mock clear to do nothing
    # Mock err to echo to stderr
    echo 'function show; echo "RUNNING: $argv"; end' > mocks.fish
    echo 'function clear; end' >> mocks.fish
    echo 'function err; echo "ERROR: $argv" >&2; end' >> mocks.fish
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "project script runs ./run if present" {
    touch run
    chmod +x run
    run fish -c "source mocks.fish; source ~/bin/project"
    [ "$status" -eq 0 ]
    [[ "$output" == *"RUNNING: ./run"* ]]
}

@test "project script runs just if Justfile present" {
    touch Justfile
    run fish -c "source mocks.fish; source ~/bin/project"
    [ "$status" -eq 0 ]
    [[ "$output" == *"RUNNING: just"* ]]
}

@test "project script runs just if justfile present" {
    touch justfile
    run fish -c "source mocks.fish; source ~/bin/project"
    [ "$status" -eq 0 ]
    [[ "$output" == *"RUNNING: just"* ]]
}

@test "project script runs lein if project.clj present" {
    touch project.clj
    run fish -c "source mocks.fish; source ~/bin/project"
    [ "$status" -eq 0 ]
    [[ "$output" == *"RUNNING: lein"* ]]
}

@test "project script runs directory-named .sh script" {
    DIR_NAME=$(basename "$TEST_DIR")
    touch "$DIR_NAME.sh"
    chmod +x "$DIR_NAME.sh"
    run fish -c "source mocks.fish; source ~/bin/project"
    [ "$status" -eq 0 ]
    [[ "$output" == *"RUNNING: ./$DIR_NAME.sh"* ]]
}

@test "project script fails if no project found" {
    run fish -c "source mocks.fish; source ~/bin/project"
    [ "$status" -eq 1 ]
    [[ "$output" == *"ERROR: Not a project"* ]]
}
