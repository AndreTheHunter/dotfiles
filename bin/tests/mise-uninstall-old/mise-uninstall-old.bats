#!/usr/bin/env bats

setup() {
    # Path to the script under test
    SCRIPT="/Users/andre/bin/mise-uninstall-old"
    
    # Create a mock bin directory and add it to PATH
    MOCK_BIN="$BATS_TEST_TMPDIR/bin"
    mkdir -p "$MOCK_BIN"
    export PATH="$MOCK_BIN:$PATH"

    # Setup mock home and strict.bash
    export HOME="$BATS_TEST_TMPDIR/home"
    mkdir -p "$HOME/.bash_functions"
    echo "set -eEuo pipefail; IFS=$'\n\t'" > "$HOME/.bash_functions/strict.bash"
    
    # Path to record mock calls
    UNINSTALL_CALLS="$BATS_TEST_TMPDIR/uninstall_calls"
}

@test "uninstalls old versions and keeps latest" {
    cat <<EOF > "$MOCK_BIN/mise"
#!/usr/bin/env bash
if [[ "\$*" == "ls --installed --json ruby" ]]; then
    echo '[{"version": "4.0.4"}, {"version": "4.0.5"}, {"version": "4.0.6"}]'
elif [[ "\$1" == "uninstall" ]]; then
    echo "\$2" >> "$UNINSTALL_CALLS"
fi
EOF
    chmod +x "$MOCK_BIN/mise"

    run "$SCRIPT" ruby
    
    [ "$status" -eq 0 ]
    [[ "$output" == *"Uninstalling ruby 4.0.4"* ]]
    [[ "$output" == *"Uninstalling ruby 4.0.5"* ]]
    [ "$(cat "$UNINSTALL_CALLS" | wc -l)" -eq 2 ]
    grep -q "ruby@4.0.4" "$UNINSTALL_CALLS"
    grep -q "ruby@4.0.5" "$UNINSTALL_CALLS"
    ! grep -q "ruby@4.0.6" "$UNINSTALL_CALLS"
}

@test "respects group argument for filtering and latest detection" {
    cat <<EOF > "$MOCK_BIN/mise"
#!/usr/bin/env bash
if [[ "\$*" == "ls --installed --json ruby" ]]; then
    echo '[{"version": "3.1.0"}, {"version": "3.2.1"}, {"version": "3.2.2"}, {"version": "4.0.6"}]'
elif [[ "\$1" == "uninstall" ]]; then
    echo "\$2" >> "$UNINSTALL_CALLS"
fi
EOF
    chmod +x "$MOCK_BIN/mise"

    # Testing group 3.2 - should keep 3.2.2 as latest of that group, uninstall 3.2.1
    # 3.1.0 and 4.0.6 should be ignored as they don't match the group grep
    run "$SCRIPT" ruby 3.2
    
    [ "$status" -eq 0 ]
    [[ "$output" == *"Uninstalling ruby 3.2.1"* ]]
    [ "$(cat "$UNINSTALL_CALLS" | wc -l)" -eq 1 ]
    grep -q "ruby@3.2.1" "$UNINSTALL_CALLS"
    ! grep -q "3.2.2" "$UNINSTALL_CALLS"
    ! grep -q "3.1.0" "$UNINSTALL_CALLS"
    ! grep -q "4.0.6" "$UNINSTALL_CALLS"
}

@test "does nothing if only one version is installed" {
    cat <<EOF > "$MOCK_BIN/mise"
#!/usr/bin/env bash
if [[ "\$*" == "ls --installed --json ruby" ]]; then
    echo '[{"version": "4.0.6"}]'
elif [[ "\$1" == "uninstall" ]]; then
    echo "\$2" >> "$UNINSTALL_CALLS"
fi
EOF
    chmod +x "$MOCK_BIN/mise"

    run "$SCRIPT" ruby
    
    [ "$status" -eq 0 ]
    [ ! -f "$UNINSTALL_CALLS" ]
}

@test "exits gracefully if no versions are found" {
    cat <<EOF > "$MOCK_BIN/mise"
#!/usr/bin/env bash
if [[ "\$*" == "ls --installed --json ruby" ]]; then
    echo '[]'
fi
EOF
    chmod +x "$MOCK_BIN/mise"

    run "$SCRIPT" ruby
    
    [ "$status" -eq 0 ]
    [ "$output" == "" ]
}

@test "handles non-existent group" {
    cat <<EOF > "$MOCK_BIN/mise"
#!/usr/bin/env bash
if [[ "\$*" == "ls --installed --json ruby" ]]; then
    echo '[{"version": "4.0.6"}]'
fi
EOF
    chmod +x "$MOCK_BIN/mise"

    run "$SCRIPT" ruby 3.2
    
    [ "$status" -eq 0 ]
    [ "$output" == "" ]
}
