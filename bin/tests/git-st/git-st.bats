#!/usr/bin/env bats

setup() {
    # Ensure git-st is in PATH
    export PATH="$HOME/bin:$PATH"
    REPO_BASE="$HOME/bin/tests/git-st/repos"
    YELLOW_BOLD=$(tput setaf 3)$(tput bold)
    NC=$(tput sgr0)
    RED=$(tput setaf 1)
}

@test "git-st in repo with no submodules" {
    cd "$REPO_BASE/no-submodules"
    run git-st
    [ "$status" -eq 0 ]
    [[ "$output" == *"In ~/bin/tests/git-st/repos/no-submodules"* ]]
    [[ "$output" == *"nothing to commit, working tree clean"* ]]
}

@test "git-st in repo with submodules" {
    cd "$REPO_BASE/with-submodules"
    run git-st
    [ "$status" -eq 0 ]
    [[ "$output" == *"In ~/bin/tests/git-st/repos/with-submodules"* ]]
    [[ "$output" == *"In ~/bin/tests/git-st/repos/with-submodules/sub1"* ]]
    [[ "$output" == *"In ~/bin/tests/git-st/repos/with-submodules/sub1/sub2"* ]]
}

@test "git-st in repo with spaces in submodule path" {
    cd "$REPO_BASE/repo-with-space"
    run git-st
    [ "$status" -eq 0 ]
    [[ "$output" == *"In ~/bin/tests/git-st/repos/repo-with-space"* ]]
    [[ "$output" == *"In ~/bin/tests/git-st/repos/repo-with-space/sub with space"* ]]
}

@test "git-st from subdirectory within a repo" {
    cd "$REPO_BASE/with-submodules"
    mkdir -p subdir
    cd subdir
    run git-st
    [ "$status" -eq 0 ]
    [[ "$output" == *"In ~/bin/tests/git-st/repos/with-submodules/subdir"* ]]
    # Should not show sub1 because it's not under subdir
    [[ ! "$output" == *"In ~/bin/tests/git-st/repos/with-submodules/sub1"* ]]
}

@test "git-st handles dirty state" {
    cd "$REPO_BASE/no-submodules"
    echo "dirty" > file.txt
    run git-st
    [ "$status" -eq 0 ]
    [[ "$output" == *"modified:   file.txt"* ]]
    # Verify no color when piped
    [[ ! "$output" == *"$YELLOW_BOLD"* ]]
    git checkout file.txt # cleanup
}

@test "git-st outputs color when in a TTY" {
    cd "$REPO_BASE/no-submodules"
    echo "dirty" >> file.txt
    run script -q /dev/null git-st
    [ "$status" -eq 0 ]
    [[ "$output" == *"${YELLOW_BOLD}In ~/bin/tests/git-st/repos/no-submodules${NC}"* ]]
    [[ "$output" == *"${RED}modified:   file.txt"* ]]
    git checkout file.txt
}

@test "git-st colorizes untracked files" {
    cd "$REPO_BASE/no-submodules"
    touch untracked.txt
    run script -q /dev/null git-st
    [ "$status" -eq 0 ]
    [[ "$output" == *"${RED}untracked.txt"* ]]
    rm untracked.txt
}

@test "git-st outputs color for submodules" {
    cd "$REPO_BASE/with-submodules"
    run script -q /dev/null git-st
    [ "$status" -eq 0 ]
    [[ "$output" == *"${YELLOW_BOLD}In ~/bin/tests/git-st/repos/with-submodules${NC}"* ]]
    [[ "$output" == *"${YELLOW_BOLD}In ~/bin/tests/git-st/repos/with-submodules/sub1${NC}"* ]]
    [[ "$output" == *"${YELLOW_BOLD}In ~/bin/tests/git-st/repos/with-submodules/sub1/sub2${NC}"* ]]
}
