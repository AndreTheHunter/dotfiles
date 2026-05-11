#!/usr/bin/env bash
set -e

# Get absolute path to the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR="$SCRIPT_DIR/repos"
mkdir -p "$REPO_DIR"
cd "$REPO_DIR"

# Allow file protocol for submodules
git config --global protocol.file.allow always

# 1. no-submodules
mkdir -p no-submodules
(
    cd no-submodules
    git init -q
    touch file.txt
    git add file.txt
    git commit -m "initial commit" -q
)

# 2. sub-repo-2 (for nesting)
mkdir -p sub-repo-2
(
    cd sub-repo-2
    git init -q
    touch sub2.txt
    git add sub2.txt
    git commit -m "sub2 commit" -q
)

# 3. sub-repo-1
mkdir -p sub-repo-1
(
    cd sub-repo-1
    git init -q
    touch sub1.txt
    git add sub1.txt
    git commit -m "sub1 commit" -q
    git submodule add -q ../sub-repo-2 sub2
    git commit -m "add nested sub2" -q
)

# 4. with-submodules
mkdir -p with-submodules
(
    cd with-submodules
    git init -q
    touch main.txt
    git add main.txt
    git commit -m "main commit" -q
    git submodule add -q ../sub-repo-1 sub1
    git commit -m "add sub1" -q
)

# 5. sub with space
mkdir -p "sub with space"
(
    cd "sub with space"
    git init -q
    touch space.txt
    git add space.txt
    git commit -m "space commit" -q
)

# 6. repo-with-space
mkdir -p repo-with-space
(
    cd repo-with-space
    git init -q
    touch main.txt
    git add main.txt
    git commit -m "main commit" -q
    git submodule add -q "../sub with space" "sub with space"
    git commit -m "add sub with space" -q
)

# 7. many-submodules (for performance testing)
mkdir -p many-submodules
(
    cd many-submodules
    git init -q
    touch main.txt
    git add main.txt
    git commit -m "main commit" -q
    for i in $(seq 1 20); do
        mkdir -p "../sub-$i"
        (
            cd "../sub-$i"
            git init -q
            touch "file-$i.txt"
            git add "file-$i.txt"
            git commit -m "sub-$i commit" -q
        )
        git submodule add -q "../sub-$i" "sub-$i"
    done
    git commit -m "add 20 submodules" -q
)

echo "Test repositories created in $REPO_DIR"
