#!/usr/bin/env bats

setup() {
    # Real home is where the actual functions and bin are
    REAL_HOME="/Users/andre"
    
    # Create a mock directory for shims
    MOCK_BIN="$BATS_TMPDIR/mock_bin"
    mkdir -p "$MOCK_BIN"
    
    # Mock HOME to avoid touching real files
    TEST_HOME="$BATS_TMPDIR/test_home"
    mkdir -p "$TEST_HOME/Projects"
    
    # Copy real bash_functions so they can be sourced
    mkdir -p "$TEST_HOME/.bash_functions"
    cp "$REAL_HOME/.bash_functions/"*.bash "$TEST_HOME/.bash_functions/"
    
    export HOME="$TEST_HOME"
    # Ensure our mocks are first in PATH, then the real PATH
    export PATH="$MOCK_BIN:$PATH"
}

teardown() {
    rm -rf "$MOCK_BIN"
    rm -rf "$TEST_HOME"
}

@test "local-clone parses SSH URL and clones into correct directory" {
    # Mock gh
    cat <<EOF > "$MOCK_BIN/gh"
#!/bin/bash
echo "owner/repo"
EOF
    chmod +x "$MOCK_BIN/gh"

    # Mock git shallow alias
    cat <<EOF > "$MOCK_BIN/git"
#!/bin/bash
if [[ "\$1" == "config" && "\$2" == "--get" && "\$3" == "alias.shallow" ]]; then
    echo "clone --depth 1 --recurse-submodules --shallow-submodules --no-tags"
    exit 0
fi
if [[ "\$1" == "shallow" ]]; then
    echo "CLONED \$2 TO \$3" > "$TEST_HOME/clone_result"
    exit 0
fi
EOF
    chmod +x "$MOCK_BIN/git"

    run local-clone git@github.com:owner/repo.git
    [ "$status" -eq 0 ]
    [ -d "$TEST_HOME/Projects/owner" ]
    [ "$(cat "$TEST_HOME/clone_result")" = "CLONED git@github.com:owner/repo.git TO $TEST_HOME/Projects/owner/repo" ]
}

@test "local-clone handles existing directory gracefully" {
    # Mock gh to return a valid slug
    cat <<EOF > "$MOCK_BIN/gh"
#!/bin/bash
echo "owner/repo"
EOF
    chmod +x "$MOCK_BIN/gh"

    mkdir -p "$TEST_HOME/Projects/owner/repo"

    run local-clone owner/repo
    [ "$status" -eq 0 ]
    [[ "$output" == *"already exists"* ]]
}


@test "local-clone fails if gh cannot resolve URL" {
    # Mock gh to fail
    cat <<EOF > "$MOCK_BIN/gh"
#!/bin/bash
exit 1
EOF
    chmod +x "$MOCK_BIN/gh"

    run local-clone invalid/url
    [ "$status" -eq 1 ]
    [[ "$output" == *"Error: Could not resolve repository"* ]]
}
